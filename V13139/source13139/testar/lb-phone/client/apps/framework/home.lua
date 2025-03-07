local CachedXEstatesData = {}

RegisterNUICallback("Home", function(data, cb)
    local action = data.action

    if action == "getHomes" then
        AVA.TriggerServerCallback('ava:estate:getMyEstates', function(xEstatesData)
            CachedXEstatesData = xEstatesData
            cb(xEstatesData)
        end)
    elseif action == 'toggleLocked' then
        TriggerServerEvent('ava:estate:toggleDoorLock', data.id)
    elseif action == "setWaypoint" then
        AVA.TriggerServerCallback('ava:estate:getPositions', function(results)
            for _, position in pairs(results) do
                SetNewWaypoint(tonumber(position.x), tonumber(position.y))
            end
            AVA.ShowNotification('~g~Position marquée sur la carte')
            cb('ok')
        end, data.id)
    elseif action == 'changeAccountId' then
        TriggerServerEvent('ava:estate:changeAccountId', data.id)
    elseif action == 'giveOwnership' then
        TriggerServerEvent('ava:estate:giveOwnership', data.id)
    end
end)