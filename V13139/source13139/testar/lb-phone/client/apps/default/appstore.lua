RegisterNetEvent("appstore:buyApp")
AddEventHandler("appstore:buyApp", function(appName, price)
    local playerPed = PlayerPedId()
    local playerId = GetPlayerServerId(PlayerId())

    if not appName or not price then
        print("^1[ERROR] Invalid parameters for buying an app.^0")
        return
    end

    print("^2[INFO] Attempting to buy app:", appName, "for", price, "$^0")

    -- Demande au serveur d'acheter l'application
    TriggerServerEvent("appstore:buyApp", playerId, price, appName)
end)

-- Exemple d'utilisation : Achat d'une application depuis un menu interactif
RegisterCommand("buyApp", function(source, args)
    if #args < 2 then
        print("^1[ERROR] Usage: /buyApp <AppName> <Price>^0")
        return
    end

    local appName = args[1]
    local price = tonumber(args[2])

    if price then
        TriggerEvent("appstore:buyApp", appName, price)
    else
        print("^1[ERROR] Invalid price format.^0")
    end
end, false)
