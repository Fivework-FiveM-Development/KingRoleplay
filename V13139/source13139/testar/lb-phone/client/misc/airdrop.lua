
RegisterNUICallback('Airdrop', function(data, cb)
    if data.action == 'getNearbyPhones' then
        local playerId = PlayerPedId()
        local position = GetEntityCoords(playerId)
        local allPhones = {}
        for _, player in pairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            if playerId ~= ped and #(position - GetEntityCoords(ped)) < 4 and IsEntityVisible(ped) then
                local serverId = GetPlayerServerId(player)
                local phoneNumber = Player(serverId).state.phoneNumber
                if phoneNumber then
                    allPhones[phoneNumber] = Player(serverId).state.phoneName
                end
            end
        end
        cb(allPhones)
    elseif data.action == 'share' then
        CB.TriggerServerCallback('phone:airdrop:share', function(received)
            cb(received)
        end, data.number, data.data)
    end
end)

RegisterNetEvent('phone:airdrop:received', function(content)
    SendReactMessage('receivedAirdrop', content)
end)
