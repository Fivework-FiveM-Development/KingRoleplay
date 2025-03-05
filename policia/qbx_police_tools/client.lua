-- Adiciona blip no mapa
RegisterNetEvent('qbx_police_tools:client:addBlip', function(x, y, z, sprite, color, label, scale, showCone)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end)

-- Remove blip do mapa
RegisterNetEvent('qbx_police_tools:client:removeBlip', function(blipId)
    if DoesBlipExist(blipId) then
        RemoveBlip(blipId)
    end
end)

-- Toca som no cliente
RegisterNetEvent('qbx_police_tools:client:playSound', function(soundName, soundSet)
    PlaySoundFrontend(-1, soundName, soundSet, true)
end)
