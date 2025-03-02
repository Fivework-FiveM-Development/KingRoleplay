local lastRobberyTime = 0
local resourceName = 'pl-atmrob'
lib.versionCheck('pulsepk/pl-atmrob')

local QBCore = exports['qb-core']:GetCoreObject()

local function HasItem(player, item)
    local Player = QBCore.Functions.GetPlayer(player)
    if Player then
        local itemData = Player.Functions.GetItemByName(item)
        return itemData and itemData.amount > 0
    end
    return false
end

lib.callback.register('pl_atmrobbery:checkforitem', function()
    local src = source
    local copcount = 0
    local xPlayers = getPlayers(src)
    for i = 1, #xPlayers, 1 do
        local xPlayer = getPlayer(xPlayers[i])
        if GetJob(src) == Config.Police.Job then
            copcount = copcount + 1
        end
    end
    return copcount >= Config.Police.required
end)

lib.callback.register('pl_atmrobbery:checkforpolice', function()
    local src = source
    local copcount = 0
    local xPlayers = getPlayers(src)
    for i = 1, #xPlayers, 1 do
        local xPlayer = getPlayer(xPlayers[i])
        if GetJob(src) == Config.Police.Job then
            copcount = copcount + 1
        end
    end
    return copcount >= Config.Police.required
end)

lib.callback.register('pl_atmrobbery:checktime', function()
    local playerId = source

    -- Primeiro verifica se o jogador tem o item
    if not HasItem(playerId, 'pendrive') then
        TriggerClientEvent('QBCore:Notify', playerId, 'Você não tem um Pendrive Hack!', 'error')
        return false
    end

    -- Agora verifica o cooldown
    if lastRobberyTime ~= 0 and (os.time() - lastRobberyTime) < Config.CooldownTimer then
        local secondsRemaining = Config.CooldownTimer - (os.time() - lastRobberyTime)
        TriggerClientEvent('QBCore:Notify', playerId, 'Você precisa esperar ' .. secondsRemaining .. ' segundos para roubar novamente!', 'error')
        return false
    end

    lastRobberyTime = os.time()
    return true
end)


RegisterServerEvent('pl_atmrobbery:MinigameResult')
AddEventHandler('pl_atmrobbery:MinigameResult', function(success)
    local src = source
    if not success then
        lastRobberyTime = 0 
    else
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.RemoveItem('pendrive', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['pendrive'], 'remove')
        end
    end
end)

RegisterNetEvent('pl_atmrobbery:GiveReward')
AddEventHandler('pl_atmrobbery:GiveReward', function(model, atmcoords)
    local src = source
    local Player = getPlayer(src)
    local Identifier = getPlayerIdentifier(src)
    local PlayerName = getPlayerName(src)
    local ped = GetPlayerPed(src)
    local distance = GetEntityCoords(ped)

    if #(distance - atmcoords) <= 5 then
        if Player then
            AddPlayerMoney(Player, Config.Reward.account, Config.Reward.amount)
            Player.Functions.AddItem('black_money', Config.Reward.amount)
            TriggerClientEvent('pl_atmrobbery:notification', src, 'You have robbed ' .. Config.Reward.amount .. ' $', 'success')
            
            -- Remover o RFID Disruptor após o roubo ser finalizado
            Player.Functions.RemoveItem('pendrive', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['pendrive'], 'remove')
        end
    else
        print('**Name:** '..PlayerName..'\n**Identifier:** '..Identifier..'** Attempted Exploit : Possible Hacker**')
    end
end)


RegisterNetEvent('pl_atmrobbery:server:policeAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = getPlayers()

    for _, v in pairs(players) do
        local xPlayer = getPlayer(v)
        
        if xPlayer and GetJob(src) == 'police' then
            local alertData = {title = "Alert", coords = {x = coords.x, y = coords.y, z = coords.z}, description = text}
            TriggerClientEvent('pl_atmrobbery:client:policeAlert', v, coords, text)
        end
    end
end)

local WaterMark = function()
    SetTimeout(1500, function()
        print('^1['..resourceName..'] ^2Thank you for Downloading the Script^0')
        print('^1['..resourceName..'] ^2If you encounter any issues please Join the discord https://discord.gg/c6gXmtEf3H to get support..^0')
        print('^1['..resourceName..'] ^2Enjoy a secret 20% OFF any script of your choice on https://pulsescripts.tebex.io/freescript^0')
        print('^1['..resourceName..'] ^2Using the coupon code: SPECIAL20 (one-time use coupon, choose wisely)^0')
    end)
end

WaterMark()
