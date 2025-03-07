
RegisterNUICallback('Trendy', function(data, cb)
    if data.action == 'isLoggedIn' then
        CB.TriggerServerCallback('phone:trendy:isLoggedIn', function(data)
            cb(data)
        end)
    elseif data.action == 'getFeed' then
        CB.TriggerServerCallback('phone:trendy:getFeed', function(data)
            cb(data)
        end, data.page)
    elseif data.action == 'swipe' then
        CB.TriggerServerCallback('phone:trendy:swipe', function(data)
            cb(data)
        end, data.number, data.like)
    elseif data.action == 'sendMessage' then
        CB.TriggerServerCallback('phone:trendy:sendMessage', function(data)
            cb(data)
        end, data.data.recipient, data.data.content, data.data.attachments)
    elseif data.action == 'createAccount' then
        CB.TriggerServerCallback('phone:trendy:createAccount', function(data)
            cb(data)
        end, data.data)
    elseif data.action == 'saveProfile' then
        CB.TriggerServerCallback('phone:trendy:updateAccount', function(data)
            cb(data)
        end, data.data)
    elseif data.action == 'getMessages' then
        CB.TriggerServerCallback('phone:trendy:getMessages', function(data)
            cb(data)
        end, data.number, data.page)
    elseif data.action == 'getMatches' then
        CB.TriggerServerCallback('phone:trendy:getMatches', function(data)
            cb(data)
        end)
    elseif data.action == 'deleteAccount' then
        CB.TriggerServerCallback('phone:trendy:deleteAccount', function(data)
            cb(data)
        end)
    end
end)


RegisterNetEvent('phone:trendy:receiveMessage', function(data)
    SendReactMessage("trendy:newMessage", data)
end)
