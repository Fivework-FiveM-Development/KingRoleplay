--------------------------------------------------------------------------------
-- Fonctions internes de gestion des messages
--------------------------------------------------------------------------------

-- Récupère l'ID d'un canal privé existant entre deux numéros
local function GetPrivateChannel(phone1, phone2)
    local query = [[
        SELECT c.id FROM phone_message_channels c
        WHERE c.is_group = 0
          AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.id AND m.phone_number = ?)
          AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = c.id AND m.phone_number = ?)
    ]]
    local params = { phone1, phone2 }
    return MySQL.scalar.await(query, params)
end

-- Fonction principale d'envoi de message
-- sender, recipient, message, attachments (table ou chaîne), callback (optionnel) et channelId (optionnel)
local function SendMessage(sender, recipient, message, attachments, callback, channelId)
    -- Vérifications de base
    if (not channelId and not recipient) or not sender then
        return
    end

    -- Si aucun message n'est fourni, on vérifie si un contenu de type tableau (par exemple un média) existe
    if not message then
        if attachments and #attachments > 0 then
            -- on considère que le message sera celui par défaut "Attachment"
            -- (vous pouvez modifier cette valeur par défaut si nécessaire)
        else
            return
        end
    end

    -- Si le message est vide, on définit un texte par défaut
    if not message or #message == 0 then
        message = "Attachment"
    end

    -- Si channelId n'est pas fourni, tente de récupérer un canal existant entre les deux numéros
    if not channelId then
        channelId = GetPrivateChannel(sender, recipient)
    end

    local sourceSender = GetSourceFromNumber(sender)

    -- Si aucun canal n'existe, on le crée
    if not channelId then
        channelId = MySQL.insert.await("INSERT INTO phone_message_channels (is_group) VALUES (0)")
        MySQL.update.await("INSERT INTO phone_message_members (channel_id, phone_number) VALUES (?, ?), (?, ?)", { channelId, sender, channelId, recipient })
        local sourceRecipient = GetSourceFromNumber(recipient)
        if sourceSender then
            TriggerClientEvent("phone:messages:newChannel", sourceSender, {
                id = channelId,
                lastMessage = message,
                timestamp = os.time() * 1000,
                number = recipient,
                isGroup = false,
                unread = false
            })
        end
        if sourceRecipient then
            TriggerClientEvent("phone:messages:newChannel", sourceRecipient, {
                id = channelId,
                lastMessage = message,
                timestamp = os.time() * 1000,
                number = sender,
                isGroup = false,
                unread = true
            })
        end
    end

    -- Log de l'envoi
    if sourceSender then
        Log("Messages", sourceSender, "info", L("BACKEND.LOGS.MESSAGE_TITLE"), L("BACKEND.LOGS.NEW_MESSAGE", {
            sender = FormatNumber(sender),
            recipient = FormatNumber(recipient),
            message = message or "Attachment"
        }))
    end

    -- Si les pièces jointes sont fournies sous forme de table, on les encode en JSON
    if type(attachments) == "table" then
        attachments = json.encode(attachments)
    end

    -- Insertion du message dans la base
    local messageId = MySQL.insert.await(
        "INSERT INTO phone_message_messages (channel_id, sender, content, attachments) VALUES (@channelId, @sender, @content, @attachments)",
        {
            ["@channelId"] = channelId,
            ["@sender"] = sender,
            ["@content"] = message,
            ["@attachments"] = attachments
        }
    )

    if not messageId then
        if callback then callback(false) end
        return
    end

    -- Mise à jour du dernier message du canal
    MySQL.update.await("UPDATE phone_message_channels SET last_message = ? WHERE id = ?", {
        string.sub(message, 1, 50),
        channelId
    })
    -- Incrément du compteur de messages non lus pour les membres autres que l'expéditeur
    MySQL.update.await("UPDATE phone_message_members SET unread = unread + 1 WHERE channel_id = ? AND phone_number != ?", { channelId, sender })
    -- Réinitialise le flag deleted du canal
    MySQL.update.await("UPDATE phone_message_members SET deleted = 0 WHERE channel_id = ?", { channelId })

    -- Récupère la liste des membres (autres que l'expéditeur)
    local members = MySQL.query.await("SELECT phone_number FROM phone_message_members WHERE channel_id = ? AND phone_number != ?", { channelId, sender })

    for i = 1, #members do
        local phone = members[i].phone_number
        if phone ~= sender then
            local srcMember = GetSourceFromNumber(phone)
            if srcMember then
                TriggerClientEvent("phone:messages:newMessage", srcMember, channelId, messageId, sender, message, attachments)
            end
            if message ~= "<!CALL-NO-ANSWER!>" then
                local contact = GetContact(sender, phone)
                SendNotification(phone, {
                    app = "Messages",
                    title = (contact and contact.name) or sender,
                    content = message,
                    thumbnail = attachments and (json.decode(attachments)[1] or nil),
                    avatar = contact and contact.avatar,
                    showAvatar = true
                })
            end
        end
    end

    if callback then
        callback(channelId)
    end

    TriggerEvent("lb-phone:messages:messageSent", {
        channelId = channelId,
        messageId = messageId,
        sender = sender,
        recipient = recipient,
        message = message,
        attachments = attachments
    })

    return { channelId = channelId, messageId = messageId }
end

-- Rendre la fonction SendMessage accessible globalement (si besoin)
SendMessage = SendMessage

--------------------------------------------------------------------------------
-- Exports
--------------------------------------------------------------------------------

-- Export "SentMoney"
exports("SentMoney", function(phone1, phone2, amount)
    assert(type(phone1) == "string", "Expected string for argument 1, got " .. type(phone1))
    assert(type(phone2) == "string", "Expected string for argument 2, got " .. type(phone2))
    assert(type(amount) == "number", "Expected number for argument 3, got " .. type(amount))
    local msg = "<!SENT-PAYMENT-" .. math.floor(amount + 0.5) .. "!>"
    SendMessage(phone1, phone2, msg)
end)

-- Export "SendCoords"
exports("SendCoords", function(phone1, phone2, coords)
    assert(type(phone1) == "string", "Expected string for argument 1, got " .. type(phone1))
    assert(type(phone2) == "string", "Expected string for argument 2, got " .. type(phone2))
    assert(type(coords) == "vector2", "Expected vector2 for argument 3, got " .. type(coords))
    local msg = "<!SENT-LOCATION-X=" .. coords.x .. "Y=" .. coords.y .. "!>"
    SendMessage(phone1, phone2, msg)
end)

-- Export "SendMessage" (redéfinition d'export si nécessaire)
exports("SendMessage", function(sender, recipient, message, attachments, callback, channelId)
    return SendMessage(sender, recipient, message, attachments, callback, channelId)
end)

-- Export "SentMoney" et "SendCoords" ont déjà été définis ci-dessus

--------------------------------------------------------------------------------
-- ESX Callbacks
--------------------------------------------------------------------------------

ESX.RegisterServerCallback("messages:sendMessage", function(source, cb, sender, recipient, message, attachments, channelId)
    -- Vérifie la présence de mots interdits
    if ContainsBlacklistedWord(source, "Messages", message) then
        return cb(false)
    end
    local result = SendMessage(sender, recipient, message, attachments, nil, channelId)
    cb(result)
end)

ESX.RegisterServerCallback("messages:createGroup", function(source, cb, owner, memberList, initialMessage, groupName)
    local channelId = MySQL.insert.await("INSERT INTO phone_message_channels (is_group) VALUES (1)")
    if not channelId then
        return cb(false)
    end

    -- Le propriétaire
    MySQL.update.await("INSERT INTO phone_message_members (channel_id, phone_number, is_owner) VALUES (?, ?, 1)", { channelId, owner })

    -- Ajout des membres non propriétaires
    local members = { { number = owner, isOwner = true } }
    for i = 1, #memberList do
        local member = memberList[i]
        MySQL.update.await("INSERT INTO phone_message_members (channel_id, phone_number, is_owner) VALUES (?, ?, 0)", { channelId, member })
        members[#members + 1] = { number = member, isOwner = false }
    end

    local groupChannel = {
        id = channelId,
        lastMessage = initialMessage,
        timestamp = os.time() * 1000,
        name = groupName,
        isGroup = true,
        members = members,
        unread = false
    }

    for i = 1, #memberList do
        local src = GetSourceFromNumber(memberList[i])
        if src then
            TriggerClientEvent("phone:messages:newChannel", src, groupChannel)
        end
    end

    TriggerClientEvent("phone:messages:newChannel", source, groupChannel)
    local sendResult = SendMessage(owner, nil, initialMessage, nil, nil, channelId)
    cb(sendResult)
end)

ESX.RegisterServerCallback("messages:renameGroup", function(source, cb, channelId, newName)
    local updated = MySQL.update.await("UPDATE phone_message_channels SET `name` = ? WHERE id = ? AND is_group = 1", { newName, channelId })
    if updated > 0 then
        TriggerClientEvent("phone:messages:renameGroup", -1, channelId, newName)
    end
    cb(updated > 0)
end)

ESX.RegisterServerCallback("messages:getRecentMessages", function(source, cb, phone)
    local query = [[
        SELECT
            c.id AS channel_id, c.is_group, c.`name`, c.last_message, c.last_message_timestamp,
            m.phone_number, m.is_owner, m.unread, m.deleted
        FROM phone_message_channels c
        INNER JOIN phone_message_members m ON m.channel_id = c.id
        WHERE EXISTS (SELECT TRUE FROM phone_message_members mm WHERE mm.channel_id = c.id AND mm.phone_number = ?)
        ORDER BY c.last_message_timestamp DESC
    ]]
    local params = { phone }
    cb(MySQL.query.await(query, params))
end)

ESX.RegisterServerCallback("messages:getMessages", function(source, cb, phone, channelId, page)
    local query = [[
        SELECT id, sender, content, attachments, `timestamp`
        FROM phone_message_messages
        WHERE channel_id = ? AND EXISTS (SELECT TRUE FROM phone_message_members m WHERE m.channel_id = ? AND m.phone_number = ?)
        ORDER BY `timestamp` DESC
        LIMIT ?, ?
    ]]
    local params = { channelId, channelId, phone, page * 25, 25 }
    cb(MySQL.query.await(query, params))
end)

ESX.RegisterServerCallback("messages:deleteMessage", function(source, cb, phone, messageId, channelId)
    if not Config.DeleteMessages then
        return cb(false)
    end
    local maxId = MySQL.scalar.await("SELECT MAX(id) FROM phone_message_messages WHERE channel_id = ?", { channelId })
    local isLast = (maxId == messageId)
    local deleted = MySQL.update.await("DELETE FROM phone_message_messages WHERE id = ? AND sender = ? AND channel_id = ?", { messageId, phone, channelId })
    deleted = deleted > 0
    if deleted and isLast then
        MySQL.update.await("UPDATE phone_message_channels SET last_message = ? WHERE id = ?", { L("APPS.MESSAGES.MESSAGE_DELETED"), channelId })
    end
    if deleted then
        TriggerClientEvent("phone:messages:messageDeleted", -1, channelId, messageId, isLast)
    end
    cb(deleted)
end)

ESX.RegisterServerCallback("messages:addMember", function(source, cb, channelId, newMember)
    local success = MySQL.update.await("INSERT IGNORE INTO phone_message_members (channel_id, phone_number) VALUES (?, ?)", { channelId, newMember })
    success = success > 0
    local src = GetSourceFromNumber(newMember)
    if success then
        TriggerClientEvent("phone:messages:memberAdded", -1, channelId, newMember)
    end
    if not src then
        return cb(success)
    end
    local members = MySQL.Sync.fetchAll("SELECT phone_number AS `number`, is_owner AS isOwner FROM phone_message_members WHERE channel_id = ?", { channelId })
    local channelData = MySQL.single.await("SELECT `name`, last_message, last_message_timestamp FROM phone_message_channels WHERE id = ?", { channelId })
    if members and channelData then
        TriggerClientEvent("phone:messages:newChannel", src, {
            id = channelId,
            lastMessage = channelData.last_message,
            timestamp = channelData.last_message_timestamp,
            name = channelData.name,
            isGroup = true,
            members = members,
            unread = false
        })
    end
    cb(success)
end)

ESX.RegisterServerCallback("messages:removeMember", function(source, cb, channelId, member)
    local isOwner = MySQL.scalar.await("SELECT is_owner FROM phone_message_members WHERE channel_id = ? AND phone_number = ?", { channelId, member })
    if not isOwner then
        return cb(false)
    end
    local success = MySQL.update.await("DELETE FROM phone_message_members WHERE channel_id = ? AND phone_number = ?", { channelId, member }) > 0
    if success then
        TriggerClientEvent("phone:messages:memberRemoved", -1, channelId, member)
    end
    cb(success)
end)

ESX.RegisterServerCallback("messages:leaveGroup", function(source, cb, phone)
    local channelId = phone  -- Ici, "phone" représente le canal concerné
    local isOwner = MySQL.scalar.await("SELECT is_owner FROM phone_message_members WHERE channel_id = ? AND phone_number = ?", { channelId, source })
    if isOwner then
        MySQL.update.await([[
            UPDATE phone_message_members
            SET is_owner = TRUE
            WHERE channel_id = ? AND phone_number != ?
            LIMIT 1
        ]], { channelId, source })
        local newOwner = MySQL.scalar.await("SELECT phone_number FROM phone_message_members WHERE channel_id = ? AND is_owner = TRUE", { channelId })
        TriggerClientEvent("phone:messages:ownerChanged", -1, channelId, newOwner)
    end
    local success = MySQL.update.await("DELETE FROM phone_message_members WHERE channel_id = ? AND phone_number = ?", { channelId, source }) > 0
    local count = MySQL.scalar.await("SELECT COUNT(1) FROM phone_message_members WHERE channel_id = ?", { channelId })
    if count == 0 then
        MySQL.update.await("DELETE FROM phone_message_channels WHERE id = ?", { channelId })
        debugprint("Deleted group " .. channelId .. " due to it being empty")
    end
    if success then
        TriggerClientEvent("phone:messages:memberRemoved", -1, channelId, source)
    end
    cb(success)
end)

ESX.RegisterServerCallback("messages:markRead", function(source, cb, channelId, phone)
    MySQL.update.await("UPDATE phone_message_members SET unread = 0 WHERE channel_id = ? AND phone_number = ?", { channelId, phone })
    cb(true)
end)

ESX.RegisterServerCallback("messages:deleteConversations", function(source, cb, phone, channelList)
    if type(channelList) ~= "table" then
        debugprint("expected table, got " .. type(channelList))
        return cb(false)
    end
    MySQL.update.await("UPDATE phone_message_members SET deleted = 1 WHERE channel_id IN (?) AND phone_number = ?", { channelList, phone })
    cb(true)
end)
