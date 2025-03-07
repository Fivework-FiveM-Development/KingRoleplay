
ESX = exports["es_extended"]:getSharedObject()

CreateThread(function()
    while ESX == nil do
        Wait(100)
    end

    exports("UsePhoneItem", function(source, item)
        if not source then return end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            TriggerClientEvent("lb-phone:usePhone", source)
        else
            print("^1[ERROR] Player not found in ESX!^0")
        end
    end)

    print("^2[INFO] UsePhoneItem export is now available!^0")
end)
