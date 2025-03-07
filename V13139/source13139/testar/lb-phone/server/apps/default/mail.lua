-- Déclaration des variables locales
local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1 = nil, nil, nil, nil, nil, nil, nil, nil, nil

----------------------------------------
-- Exporter la fonction GetEmailAddress
----------------------------------------
L0_1 = exports
L1_1 = "GetEmailAddress"
local function GetEmailAddress(account)
  return GetLoggedInAccount(account, "Mail")
end
if L0_1 then
  L0_1(L1_1, GetEmailAddress)
end

-------------------------------------------------------------
-- Exporter une fonction pour enregistrer des callbacks "mail:"
-------------------------------------------------------------
if exports then
  exports("RegisterMailCallback", function(name, callback, fallback)
    ESX.RegisterServerCallback("mail:" .. name, function(source, ...)
      local account = GetLoggedInAccount(source, "Mail")
      if not account then
        return fallback
      end
      return callback(source, account, ...)
    end)
  end)
end

--------------------------------------------------------
-- Notifier les comptes connectés pour l'application Mail
--------------------------------------------------------
local function NotifyMailToLoggedInAccounts(username, notification, excludeNumber)
  local accounts = MySQL.query.await(
    "SELECT phone_number FROM phone_logged_in_accounts WHERE username = ? AND app = 'Mail' AND `active` = 1",
    { username }
  )
  notification.app = "Mail"
  for i = 1, #accounts do
    local phone = accounts[i].phone_number
    if phone ~= excludeNumber then
      SendNotification(phone, notification)
    end
  end
end

----------------------------------------------------------
-- Exporter une fonction "isLoggedIn" pour l'application Mail
----------------------------------------------------------
if exports then
  exports("isLoggedIn", function(source, account, fallback)
    return fallback
  end)
end

-----------------------------------------------------------
-- Création d'un compte Mail (fonction interne)
-----------------------------------------------------------
local function CreateMailAccount(address, password, callback)
  if not address or not password or #address < 3 or #password < 3 then
    if callback then callback({ success = false, reason = "Invalid email / password" }) end
    return false, "Invalid email / password"
  end

  local hashedPass = GetPasswordHash(password)
  local exists = MySQL.scalar.await("SELECT 1 FROM phone_mail_accounts WHERE address=?", { address })
  if exists then
    if callback then callback({ success = false, error = "Address already exists" }) end
    return false, "Address already exists"
  end

  local result = MySQL.update.await(
    "INSERT INTO phone_mail_accounts (address, `password`) VALUES (?, ?)",
    { address, hashedPass }
  )
  if result ~= 1 then
    if callback then callback({ success = false, error = "Server error" }) end
    return false, "Server error"
  end

  if callback then callback({ success = true }) end
  return true
end

-- Export de CreateMailAccount
if exports then
  exports("CreateMailAccount", CreateMailAccount)
end

-----------------------------------------------------------
-- Callback ESX pour "mail:createAccount"
-----------------------------------------------------------
ESX.RegisterServerCallback("mail:createAccount", function(source, cb, emailName, password)
  if #emailName < 3 or #password < 3 then
    return cb({ success = false, error = "Invalid email / password" })
  end
  emailName = emailName .. "@" .. Config.EmailDomain
  local success, err = CreateMailAccount(emailName, password)
  if success then
    AddLoggedInAccount(source, "Mail", emailName)
  end
  cb({ success = success, error = err })
end)

-----------------------------------------------------------
-- Exporter la fonction "changePassword" pour Mail
-----------------------------------------------------------
if exports then
  exports("changePassword", function(source, phone, address, oldPassword, newPassword)
    if not Config.ChangePassword or not Config.ChangePassword.Mail then
      infoprint("warning", ("%s tried to change password on Mail, but it's not enabled in the config."):format(source))
      return false
    end
    if oldPassword ~= newPassword and #newPassword < 3 then
      debugprint("same password / too short")
      return false
    end
    local currentHash = MySQL.scalar.await("SELECT password FROM phone_mail_accounts WHERE address = ?", { address })
    if not currentHash or not VerifyPasswordHash(oldPassword, currentHash) then
      return false
    end
    local updated = MySQL.update.await("UPDATE phone_mail_accounts SET password = ? WHERE address = ?", { GetPasswordHash(newPassword), address })
    if updated <= 0 then
      return false
    end
    NotifyMailToLoggedInAccounts(address, {
      title = L("BACKEND.MISC.LOGGED_OUT_PASSWORD.TITLE"),
      content = L("BACKEND.MISC.LOGGED_OUT_PASSWORD.DESCRIPTION")
    }, phone)
    MySQL.update.await("DELETE FROM phone_logged_in_accounts WHERE username = ? AND app = 'Mail' AND phone_number != ?", { address, phone })
    ClearActiveAccountsCache("Mail", address, phone)
    Log("Mail", source, "info", L("BACKEND.LOGS.CHANGED_PASSWORD.TITLE"),
      L("BACKEND.LOGS.CHANGED_PASSWORD.DESCRIPTION", { number = phone, username = address, app = "Mail" }))
    TriggerClientEvent("phone:logoutFromApp", -1, {
      username = address,
      app = "mail",
      reason = "password",
      number = phone
    })
    return true
  end)
end

-----------------------------------------------------------
-- Exporter la fonction "deleteAccount" pour Mail
-----------------------------------------------------------
if exports then
  exports("deleteAccount", function(source, phone, address, password)
    if not Config.DeleteAccount or not Config.DeleteAccount.Mail then
      infoprint("warning", ("%s tried to delete their account on Mail, but it's not enabled in the config."):format(source))
      return false
    end
    local currentHash = MySQL.scalar.await("SELECT password FROM phone_mail_accounts WHERE address = ?", { address })
    if not currentHash or not VerifyPasswordHash(password, currentHash) then
      return false
    end
    local deleted = MySQL.update.await("DELETE FROM phone_mail_accounts WHERE address = ?", { address })
    if deleted <= 0 then
      return false
    end
    NotifyMailToLoggedInAccounts(address, {
      title = L("BACKEND.MISC.DELETED_NOTIFICATION.TITLE"),
      content = L("BACKEND.MISC.DELETED_NOTIFICATION.DESCRIPTION")
    })
    MySQL.update.await("DELETE FROM phone_logged_in_accounts WHERE username = ? AND app = 'Mail'", { address })
    ClearActiveAccountsCache("Mail", address)
    Log("Mail", source, "info", L("BACKEND.LOGS.DELETED_ACCOUNT.TITLE"),
      L("BACKEND.LOGS.DELETED_ACCOUNT.DESCRIPTION", { number = phone, username = address, app = "Mail" }))
    TriggerClientEvent("phone:logoutFromApp", -1, { username = address, app = "mail", reason = "deleted" })
    return true
  end)
end

-----------------------------------------------------------
-- Callback ESX pour "mail:login"
-----------------------------------------------------------
ESX.RegisterServerCallback("mail:login", function(source, cb, address, password)
  local hash = MySQL.scalar.await("SELECT `password` FROM phone_mail_accounts WHERE address=?", { address })
  if not hash then
    return cb({ success = false, error = "Invalid address" })
  end
  if not VerifyPasswordHash(password, hash) then
    return cb({ success = false, error = "Invalid password" })
  end
  AddLoggedInAccount(source, "Mail", address)
  cb({ success = true })
end)

-----------------------------------------------------------
-- Exporter la fonction "logout" pour Mail
-----------------------------------------------------------
if exports then
  exports("logout", function(source, phone, address)
    RemoveLoggedInAccount(phone, "Mail", address)
    return { success = true }
  end)
end

-----------------------------------------------------------
-- Fonction interne pour notifier l'envoi d'un mail
-----------------------------------------------------------
local function MailSentNotification(mailData)
  if mailData.to == "all" then
    TriggerClientEvent("phone:mail:newMail", -1, mailData)
    return
  end
  local accounts = MySQL.query.await("SELECT phone_number FROM phone_logged_in_accounts WHERE app = 'Mail' AND username = ?", { mailData.to })
  for _, acc in pairs(accounts) do
    local src = GetSourceFromNumber(acc.phone_number)
    if src then
      TriggerClientEvent("phone:mail:newMail", src, mailData)
    end
    SendNotification(acc.phone_number, {
      app = "Mail",
      title = mailData.sender,
      content = mailData.subject,
      thumbnail = (mailData.attachments and mailData.attachments[1]) or nil
    })
  end
end

-----------------------------------------------------------
-- Fonction d'envoi de mail (interne)
-----------------------------------------------------------
local function SendMail(messageData)
  if messageData.to and messageData.to ~= "all" then
    local exists = MySQL.scalar.await("SELECT 1 FROM phone_mail_accounts WHERE address = ?", { messageData.to })
    if not exists then
      return false, "Invalid address"
    end
  end
  messageData.attachments = messageData.attachments or {}
  messageData.actions = messageData.actions or {}

  local id = MySQL.insert.await([[
    INSERT INTO phone_mail_messages (recipient, sender, subject, content, attachments, actions)
    VALUES (@recipient, @sender, @subject, @content, @attachments, @actions)
  ]], {
    ["@recipient"] = messageData.to,
    ["@sender"]    = messageData.sender or "system",
    ["@subject"]   = messageData.subject or "System mail",
    ["@content"]   = messageData.message or "",
    ["@attachments"] = (#messageData.attachments > 0) and json.encode(messageData.attachments) or nil,
    ["@actions"]     = (#messageData.actions > 0) and json.encode(messageData.actions) or nil
  })

  local mail = {
    id = id,
    to = messageData.to,
    sender = messageData.sender or "System",
    subject = messageData.subject or "System mail",
    message = messageData.message or "",
    attachments = messageData.attachments,
    actions = messageData.actions,
    read = false,
    timestamp = os.time() * 1000
  }

  TriggerEvent("lb-phone:mail:mailSent", mail)
  MailSentNotification(mail)
  return true, id
end

-- Exporter SendMail
if exports then
  exports("SendMail", SendMail)
end

-----------------------------------------------------------
-- Génération automatique d'un compte mail
-----------------------------------------------------------
local function GenerateEmailAccount(source, phone)
  if not Config.AutoCreateEmail or not phone then
    return
  end
  local firstName, lastName = GetCharacterName(source)
  firstName = firstName:gsub("[^%w]", "")
  lastName  = lastName:gsub("[^%w]", "")
  if #firstName == 0 then
    firstName = GenerateString(5)
  end
  if #lastName == 0 then
    lastName = GenerateString(5)
  end
  local emailPrefix = firstName .. "." .. lastName
  local count = MySQL.scalar.await("SELECT COUNT(1) FROM phone_mail_accounts WHERE address LIKE ?", { emailPrefix .. "%" }) or 0
  if count > 0 then
    emailPrefix = emailPrefix .. (count + 1)
  end
  local emailAddress = emailPrefix .. "@" .. Config.EmailDomain
  local password = GenerateString(5)
  local success = CreateMailAccount(emailAddress, password)
  if not success then
    return
  end
  AddLoggedInAccount(phone, "Mail", emailAddress)
  SendMail({
    to = emailAddress,
    sender = L("BACKEND.MAIL.AUTOMATIC_PASSWORD.SENDER"),
    subject = L("BACKEND.MAIL.AUTOMATIC_PASSWORD.SUBJECT"),
    message = L("BACKEND.MAIL.AUTOMATIC_PASSWORD.MESSAGE", { address = emailAddress, password = password })
  })
end
GenerateEmailAccount = GenerateEmailAccount

-----------------------------------------------------------
-- Exporter la fonction "DeleteMail" pour supprimer un mail
-----------------------------------------------------------
if exports then
  exports("DeleteMail", function(id)
    local result = MySQL.Sync.execute("DELETE FROM phone_mail_messages WHERE id=@id", { ["@id"] = id })
    if result > 0 then
      TriggerClientEvent("phone:mail:mailDeleted", -1, id)
    end
    return result > 0
  end)
end

-----------------------------------------------------------
-- Exporter la fonction "sendMail" pour envoyer un mail
-----------------------------------------------------------
if exports then
  exports("sendMail", function(source, sender, messageData)
    if messageData.to == "all" then
      return false
    end
    if not (messageData.to and messageData.subject and messageData.message and type(messageData.attachments) == "table") then
      return false
    end
    if ContainsBlacklistedWord(source, "Mail", messageData.subject) or
       ContainsBlacklistedWord(source, "Mail", messageData.message) then
      return false
    end
    local success, mailId = SendMail(messageData)
    if not success then
      return false
    end
    Log("Mail", source, "info", L("BACKEND.LOGS.MAIL_TITLE"),
      L("BACKEND.LOGS.NEW_MAIL", { sender = sender, recipient = messageData.to }))
    return mailId
  end)
end

-----------------------------------------------------------
-- Exporter la fonction "getMails" pour récupérer les mails
-----------------------------------------------------------
if exports then
  exports("getMails", function(source, phone, address, page)
    local extraCondition = ""
    if Config.DeleteMail then
      extraCondition = "AND IF((SELECT 1 FROM phone_mail_deleted d WHERE d.message_id=m.id AND d.address=@address), FALSE, TRUE)"
    end
    local query = ([[
      SELECT id, recipient AS `to`, sender, subject, LEFT(content, 70) AS message, `read`, `timestamp`
      FROM phone_mail_messages m
      WHERE (
          recipient=@address
          OR recipient="all"
          OR sender=@address
      ) %s
      ORDER BY `timestamp` DESC
      LIMIT @page, @perPage
    ]]):format(extraCondition)
    local params = {
      ["@address"] = address,
      ["@page"] = (page or 0) * 10,
      ["@perPage"] = 10
    }
    return MySQL.query.await(query, params)
  end)
end

-----------------------------------------------------------
-- Exporter la fonction "getMail" pour récupérer un mail spécifique
-----------------------------------------------------------
if exports then
  exports("getMail", function(source, phone, address, id)
    local result = MySQL.single.await([[
      SELECT id, recipient AS `to`, sender, subject, content as message, attachments, `read`, `timestamp`, actions
      FROM phone_mail_messages
      WHERE (
          recipient=@address
          OR recipient="all"
          OR sender=@address
      ) AND id=@id
    ]], { ["@address"] = address, ["@id"] = id })
    if not result then
      return false
    end
    if not result.read then
      MySQL.update.await("UPDATE phone_mail_messages SET `read`=1 WHERE id=? AND sender != ?", { id, address })
    end
    return result
  end)
end

-----------------------------------------------------------
-- Exporter la fonction "deleteMail" pour marquer un mail comme supprimé
-----------------------------------------------------------
if exports then
  exports("deleteMail", function(source, phone, address, messageId)
    if not Config.DeleteMail then return end
    MySQL.update.await("INSERT IGNORE INTO phone_mail_deleted (message_id, address) VALUES (?, ?)", { messageId, address })
    return true
  end)
end

-----------------------------------------------------------
-- Exporter la fonction "search" pour rechercher des mails
-----------------------------------------------------------
if exports then
  exports("search", function(source, phone, address, queryStr, page)
    local extraCondition = ""
    if Config.DeleteMail then
      extraCondition = "AND IF((SELECT 1 FROM phone_mail_deleted d WHERE d.message_id=m.id AND d.address=@address), FALSE, TRUE)"
    end
    local query = ([[
      SELECT id, recipient AS `to`, sender, subject, LEFT(content, 70) AS message, `read`, `timestamp`
      FROM phone_mail_messages m
      WHERE (
          recipient=@address
          OR recipient="all"
          OR sender=@address
      ) AND (
          recipient LIKE @query
          OR recipient="all"
          OR sender LIKE @query
          OR subject LIKE @query
          OR content LIKE @query
      ) %s
      ORDER BY `timestamp` DESC
      LIMIT @page, @perPage
    ]]):format(extraCondition)
    local params = {
      ["@address"] = address,
      ["@query"] = "%" .. queryStr .. "%",
      ["@page"] = (page or 0) * 10,
      ["@perPage"] = 10
    }
    return MySQL.query.await(query, params)
  end)
end