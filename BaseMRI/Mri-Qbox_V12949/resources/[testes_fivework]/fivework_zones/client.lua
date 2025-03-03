local zonasAtivas = {}

-- Evento para criar uma zona no minimapa
RegisterNetEvent("zonas:criarZona")
AddEventHandler("zonas:criarZona", function(nome, zona)
    print("[DEBUG] Recebido zonas:criarZona - Nome: " .. nome .. ", Coords: x=" .. zona.x .. ", y=" .. zona.y .. ", z=" .. zona.z .. ", Raio: " .. zona.raio)

    -- Cria o blip no minimapa
    local blip = AddBlipForRadius(zona.x, zona.y, zona.z, zona.raio + 0.0)
    if DoesBlipExist(blip) then
        SetBlipColour(blip, 1) -- Vermelho
        SetBlipAlpha(blip, 255) -- Totalmente visível
        SetBlipAsShortRange(blip, false) -- Visível em todo o mapa
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zona: " .. nome) -- Nome do blip no mapa
        EndTextCommandSetBlipName(blip)
        print("[DEBUG] Blip criado para zona " .. nome .. " - Handle: " .. blip)
    else
        print("[ERROR] Falha ao criar blip para zona " .. nome)
        return
    end

    zonasAtivas[nome] = { blip = blip }
end)

-- Evento para remover uma zona do minimapa
RegisterNetEvent("zonas:removerZona")
AddEventHandler("zonas:removerZona", function(nome)
    if zonasAtivas[nome] and DoesBlipExist(zonasAtivas[nome].blip) then
        RemoveBlip(zonasAtivas[nome].blip)
        print("[DEBUG] Blip removido para zona " .. nome)
    else
        print("[ERROR] Blip não encontrado para zona " .. nome)
    end
    zonasAtivas[nome] = nil
end)