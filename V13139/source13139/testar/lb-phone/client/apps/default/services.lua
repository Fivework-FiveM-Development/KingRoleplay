RegisterNUICallback('Services', function(data, cb)
    if data.action == 'getCompany' then
        AVA.TriggerServerCallback('ava:phone:getCompanyData', cb)
    elseif data.action == 'toggleDuty' then
        AVA.ShowNotification('~r~Not implemented')
        -- TODO
    elseif data.action == 'hireEmployee' then
        AVA.ShowNotification('~r~Not implemented')
        -- TODO
    elseif data.action == 'setGrade' then
        AVA.ShowNotification('~r~Not implemented')
        -- TODO
    elseif data.action == 'fireEmployee' then
        AVA.ShowNotification('~r~Not implemented')
        -- TODO
    elseif data.action == 'deleteChannel' then
        CB.TriggerServerCallback('phone:services:deleteChannel', function(data)
            cb(data)
        end, data.id)
    elseif data.action == 'getMessages' then
        CB.TriggerServerCallback('phone:services:getMessages', function(data)
            cb(data)
        end, data.id, data.page, data.company)
    elseif data.action == 'sendMessage' then
        CB.TriggerServerCallback('phone:services:sendMessage', function(data)
            cb(data)
        end, data.id, data.company, data.content)
    elseif data.action == 'getCompanies' then
        CB.TriggerServerCallback('phone:services:getOnline', function(data)
            cb(data)
        end, data)
    elseif data.action == 'getChannelId' then
        CB.TriggerServerCallback('phone:services:getChannelId', function(data)
            cb(data)
        end, data.company)
    elseif data.action == 'getRecentMessages' then
        CB.TriggerServerCallback('phone:services:getRecentMessages', function(data)
            cb(data)
        end, data.page)
    end
end)

RegisterNetEvent('phone:services:newMessage', function(data)
    SendReactMessage('services:newMessage', data)
end)