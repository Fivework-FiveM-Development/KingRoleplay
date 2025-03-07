GlobalMapsBlips = {}

RegisterNUICallback('Maps', function(data, cb)
    if data.action == 'getCurrentLocation' then
        if data.isGps then
            if IsWaypointActive() then
                cb({
                    x = GetBlipInfoIdCoord(GetFirstBlipInfoId(8)).x,
                    y = GetBlipInfoIdCoord(GetFirstBlipInfoId(8)).y,
                })
            else
                cb(false)
            end
        else
            cb({
                x = GetEntityCoords(PlayerPedId()).x,
                y = GetEntityCoords(PlayerPedId()).y,
            })
        end
    elseif data.action == 'setWaypoint' then
        local x = tonumber(data.data.x)
        local y = tonumber(data.data.y)
        if not x or not y or (x == 0 and y == 0) then
            AVA.ShowNotification('~r~Position invalide...')
            return cb(false)
        end
        SetNewWaypoint(x + 0.0, y + 0.0)
        AVA.ShowNotification('~g~Position marquée sur la carte')
        cb(true)
    elseif data.action == 'getData' then
        cb(GlobalMapsBlips)
    end
end)

RegisterNetEvent('ava:blips:updateAll', function(blips)
    if not blips then return end

    for blipId, blipData in pairs(blips) do
        GlobalMapsBlips[blipId] = blipData ~= 0 and blipData or nil
    end
end)

RegisterNetEvent('ava:blips:patchPlayerBlips', function(blipId, blipData)
    GlobalMapsBlips[blipId] = blipData
end)