print("[---------------------------------------------------------------]")
print("          Script Carregado com Sucesso! - "..GetCurrentResourceName()) 
print("[---------------------------------------------------------------]")

local zonas = {}
local jsonFile = "zonas.json"

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

-- Função para verificar permissão
local function HasPermission(src)
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then
        return false
    end

    local job = Player.PlayerData.job.name
    local allowedJobs = {
        "police", -- Ajuste conforme o nome do cargo no seu servidor
        -- Adicione mais cargos aqui, ex.: "sheriff"
    }

    for _, allowedJob in ipairs(allowedJobs) do
        if job == allowedJob then
            return true
        end
    end
    return false
end

-- Registro do comando /zonas
RegisterCommand("zonas", function(source, args, rawCommand)
    local src = source

    -- Verifica permissão
    if not HasPermission(src) then
        exports.qbx_core:Notify(src, "Você não tem permissão para usar este comando!", "error")
        print("[DEBUG] Jogador " .. src .. " sem permissão tentou usar /zonas")
        return
    end

    local nome = args[1]
    local raio = tonumber(args[2])

    -- Verifica argumentos
    if not nome or not raio or raio <= 0 then
        exports.qbx_core:Notify(src, "Uso: /zonas [nome] [raio]", "error")
        print("[DEBUG] Argumentos inválidos: nome=" .. tostring(nome) .. ", raio=" .. tostring(raio))
        return
    end

    -- Verifica se a zona já existe
    if zonas[nome] then
        exports.qbx_core:Notify(src, "Já existe uma zona com esse nome!", "error")
        return
    end

    -- Pega as coordenadas do jogador
    local coords = GetEntityCoords(GetPlayerPed(src))
    print("[DEBUG] Coordenadas do jogador " .. src .. ": x=" .. coords.x .. ", y=" .. coords.y .. ", z=" .. coords.z)

    -- Cria a zona
    local zona = {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        raio = raio,
        createdAt = os.time()
    }

    -- Salva na tabela e no JSON
    zonas[nome] = zona
    SaveZonas()

    -- Notifica o jogador que criou a zona
    exports.qbx_core:Notify(src, "Zona '" .. nome .. "' criada com raio de " .. raio .. "m!", "success")
    print("[DEBUG] Enviando evento para criar zona: " .. nome)

    -- Envia a zona para todos os clientes
    TriggerClientEvent("zonas:criarZona", -1, nome, zona)

    -- Remove a zona após 5 minutos
    SetTimeout(300000, function()
        if zonas[nome] then
            zonas[nome] = nil
            SaveZonas()
            TriggerClientEvent("zonas:removerZona", -1, nome)
            exports.qbx_core:Notify(src, "Zona '" .. nome .. "' foi removida!", "success")
            print("[DEBUG] Zona removida: " .. nome)
        end
    end)
end, false)

-- Sincroniza zonas para novos jogadores
AddEventHandler("playerConnecting", function()
    local src = source
    for nome, zona in pairs(zonas) do
        TriggerClientEvent("zonas:criarZona", src, nome, zona)
        print("[DEBUG] Sincronizando zona " .. nome .. " para jogador " .. src)
    end
end)