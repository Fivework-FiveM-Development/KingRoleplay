local zonasAtivas = {}

RegisterNetEvent("redzones:criarZona")
AddEventHandler("redzones:criarZona", function(zonaId, zona)
    print("[DEBUG] Criando zona: " .. zonaId .. ", x=" .. zona.x .. ", y=" .. zona.y .. ", z=" .. zona.z .. ", raio=" .. zona.raio)
    
    local blip = AddBlipForRadius(zona.x, zona.y, zona.z, zona.raio + 0.0)
    if DoesBlipExist(blip) then
        SetBlipColour(blip, 1)
        SetBlipAlpha(blip, 255)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Área Vermelha: " .. zona.texto)
        EndTextCommandSetBlipName(blip)
        print("[DEBUG] Blip criado: " .. blip)
    else
        print("[ERROR] Falha ao criar blip para " .. zonaId)
    end

    zonasAtivas[zonaId] = { blip = blip }
end)

RegisterNetEvent("redzones:removerZona")
AddEventHandler("redzones:removerZona", function(zonaId)
    if zonasAtivas[zonaId] and DoesBlipExist(zonasAtivas[zonaId].blip) then
        RemoveBlip(zonasAtivas[zonaId].blip)
        print("[DEBUG] Blip removido para " .. zonaId)
    else
        print("[ERROR] Blip não encontrado para " .. zonaId)
    end
    zonasAtivas[zonaId] = nil
end)