-- Obtm o core do QBox
local QBCore = exports['qbx-core']:GetCoreObject()

-- Tabela para rastrear blips do comando 'p'
local policeBlips = {}

-- Comando 'ptr': Lista oficiais em servio
RegisterCommand('ptr', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Verifica se o jogador tem permisso de polcia ou admin
    local hasPermission = QBCore.Functions.HasPermission(src, 'police') or QBCore.Functions.HasPermission(src, 'admin')
    if not hasPermission then return end

    -- Obtm todos os jogadores online
    local players = QBCore.Functions.GetPlayers()
    local officers = {}
    local officerCount = 0

    -- Filtra jogadores com permissão de polícia
    for _, playerId in ipairs(players) do
        local targetPlayer = QBCore.Functions.GetPlayer(playerId)
        if targetPlayer and QBCore.Functions.HasPermission(playerId, 'police') then
            local identity = targetPlayer.PlayerData.charinfo
            table.insert(officers, string.format('<b>%d<b>: %s %s', playerId, identity.firstname, identity.lastname))
            officerCount = officerCount + 1
        end
    end

    -- Envia notificações ao jogador
    TriggerClientEvent('QBCore:Notify', src, string.format('Atualmente <b>%d Oficiais</b> em serviço.', officerCount), 'primary')
    if officerCount > 0 then
        local officerList = table.concat(officers, '<br>')
        TriggerClientEvent('QBCore:Notify', src, officerList, 'primary')
    end
end, false)

-- Comando 'p': Compartilha localização com outros policiais
RegisterCommand('p', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Verifica se o jogador tem permissão de polícia
    if not QBCore.Functions.HasPermission(src, 'police') then return end
    
    -- Verifica se o jogador está vivo
    local ped = GetPlayerPed(src)
    if GetEntityHealth(ped) <= 0 then return end

    -- Obtém posição do jogador
    local coords = GetEntityCoords(ped)
    local x, y, z = coords.x, coords.y, coords.z

    -- Obtém identidade do jogador
    local identity = Player.PlayerData.charinfo
    local fullName = identity.firstname .. " " .. identity.lastname

    -- Obtém todos os jogadores online
    local players = QBCore.Functions.GetPlayers()

    -- Envia localização para outros policiais
    for _, playerId in ipairs(players) do
        local targetPlayer = QBCore.Functions.GetPlayer(playerId)
        if targetPlayer and playerId ~= src and QBCore.Functions.HasPermission(playerId, 'police') then
            Citizen.CreateThread(function()
                local blipId = math.random(1, 999999) -- ID único simples
                policeBlips[blipId] = blipId

                -- Adiciona blip no mapa do outro policial
                TriggerClientEvent('qbx_police_tools:client:addBlip', playerId, x, y, z, 153, 84, "Localização de " .. fullName, 0.5, false)

                -- Envia notificação push ao outro policial
                TriggerClientEvent('QBCore:Notify', playerId, {
                    code = "TH",
                    title = "Localização Recebida de:",
                    x = x,
                    y = y,
                    z = z,
                    badge = fullName
                }, 'primary')

                -- Toca som para o receptor (opcional)
                -- TriggerClientEvent('qbx_police_tools:client:playSound', playerId, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS")

                -- Remove o blip após 60 segundos
                Wait(60000)
                TriggerClientEvent('qbx_police_tools:client:removeBlip', playerId, blipId)
                policeBlips[blipId] = nil
            end)
        end
    end

    -- Notifica o jogador que enviou a localização
    TriggerClientEvent('QBCore:Notify', src, "Localização enviada com sucesso.", 'success')

    -- Toca som para o jogador que enviou
    TriggerClientEvent('qbx_police_tools:client:playSound', src, "Event_Message_Purple", "GTAO_FM_Events_Soundset")
end, false)
