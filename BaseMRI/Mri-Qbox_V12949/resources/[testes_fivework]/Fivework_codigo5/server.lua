print("[---------------------------------------------------------------]")
print("          Script Carregado com Sucesso! - "..GetCurrentResourceName()) 
print("[---------------------------------------------------------------]")

local zonas = {}
local jsonFile = "areavermelha.json"

-- Função para carregar zonas do JSON
local function LoadZonas()
    if not LoadResourceFile(GetCurrentResourceName(), jsonFile) then
        SaveResourceFile(GetCurrentResourceName(), jsonFile, json.encode({}), -1)
    end
    local file = LoadResourceFile(GetCurrentResourceName(), jsonFile)
    zonas = json.decode(file) or {}
    print("[DEBUG] Zonas carregadas do JSON: " .. json.encode(zonas))
end

-- Função para salvar zonas no JSON
local function SaveZonas()
    SaveResourceFile(GetCurrentResourceName(), jsonFile, json.encode(zonas, { indent = true }), -1)
    print("[DEBUG] Zonas salvas no JSON: " .. json.encode(zonas))
end

-- Carrega zonas ao iniciar o recurso
LoadZonas()

-- Carrega permissões de sets.json
local function LoadSets()
    local setsFile = LoadResourceFile(GetCurrentResourceName(), "sets.json")
    if not setsFile then
        print("[ERROR] sets.json não encontrado! Criando padrão...")
        local defaultSets = { allowed_jobs = {"police"} }
        SaveResourceFile(GetCurrentResourceName(), "sets.json", json.encode(defaultSets, { indent = true }), -1)
        return defaultSets
    end
    local sets = json.decode(setsFile)
    if not sets or not sets.allowed_jobs then
        print("[ERROR] sets.json inválido! Usando padrão...")
        return { allowed_jobs = {"police"} }
    end
    print("[DEBUG] Sets carregados: " .. json.encode(sets))
    return sets
end

local sets = LoadSets()

-- Função para verificar permissão (baseada no modelo fornecido)
local function HasPermission(src)
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then
        print("[DEBUG] Jogador " .. src .. " não encontrado no QBox!")
        return false
    end

    local job = Player.PlayerData.job.name
    local allowedJobs = sets.allowed_jobs -- Carrega diretamente do sets.json

    print("[DEBUG] Verificando - Jogador: " .. src .. ", Job atual: " .. tostring(job))
    print("[DEBUG] Jobs permitidos: " .. table.concat(allowedJobs, ", "))

    for _, allowedJob in ipairs(allowedJobs) do
        if job == allowedJob then
            print("[DEBUG] Permissão concedida para " .. src .. " - Job: " .. job)
            return true
        end
    end
    print("[DEBUG] Jogador " .. src .. " sem permissão - Job: " .. tostring(job))
    return false
end

-- Registro do comando /areavermelha
RegisterCommand("areavermelha", function(source, args, rawCommand)
    local src = source

    -- Verifica permissão
    if not HasPermission(src) then
        exports.qbx_core:Notify(src, "Você não tem permissão para usar este comando!", "error")
        print("[DEBUG] Jogador " .. src .. " sem permissão tentou usar /areavermelha")
        return
    end

    local texto = args[1]
    local raio = tonumber(args[2])

    -- Verifica argumentos
    if not texto or not raio or raio <= 0 then
        exports.qbx_core:Notify(src, "Uso: /areavermelha [TEXTO] [RAIO]", "error")
        print("[DEBUG] Argumentos inválidos: texto=" .. tostring(texto) .. ", raio=" .. tostring(raio))
        return
    end

    local coords = GetEntityCoords(GetPlayerPed(src))
    local zonaId = "zona_" .. os.time()

    local zona = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        raio = raio,
        texto = texto,
        createdAt = os.time()
    }

    zonas[zonaId] = zona
    SaveZonas()

    -- Notifica todos os jogadores
    
    -- notificação global da area criada / demora 50 segundos para sair a ntificação
    exports.qbx_core:Notify(-1, "ATENÇÃO: " .. texto, "error", 50000) 
    print("[DEBUG] Área vermelha criada: " .. zonaId .. " - Texto: " .. texto .. ", Raio: " .. raio)

    -- Envia a zona para todos os clientes
    TriggerClientEvent("redzones:criarZona", -1, zonaId, zona)

    -- Remove a zona após 5 minutos
    SetTimeout(300000, function() -- > duração da zona = 300.000 ms
        if zonas[zonaId] then
            zonas[zonaId] = nil
            SaveZonas()
            TriggerClientEvent("redzones:removerZona", -1, zonaId)
            exports.qbx_core:Notify(src, "Área vermelha '" .. zonaId .. "' foi removida!", "success")
            print("[DEBUG] Área vermelha removida: " .. zonaId)
        end
    end)
end, false)

-- Sincroniza zonas para novos jogadores
AddEventHandler("playerConnecting", function()
    local src = source
    for zonaId, zona in pairs(zonas) do
        TriggerClientEvent("redzones:criarZona", src, zonaId, zona)
        print("[DEBUG] Sincronizando zona " .. zonaId .. " para jogador " .. src)
    end
end)