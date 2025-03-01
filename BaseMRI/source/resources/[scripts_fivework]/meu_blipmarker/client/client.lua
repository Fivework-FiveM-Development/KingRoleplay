Citizen.CreateThread(function()
    for _, blipData in pairs(Config.Blips) do
        local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)
        SetBlipSprite(blip, blipData.icon)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, blipData.size)
        SetBlipColour(blip, blipData.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(blipData.name)
        EndTextCommandSetBlipName(blip)
    end
end)
