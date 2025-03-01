
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        -- Processa drawmarkers
        for _, marker in ipairs(Config.DrawMarkers) do
            if #(playerCoords - marker.coords) < marker.distance then
                -- Desenha drawmarker
                DrawMarker(marker.type, marker.coords.x, marker.coords.y, marker.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, marker.scale.x, marker.scale.y, marker.scale.z, marker.color.r, marker.color.g, marker.color.b, 255, false, true, 2, nil, nil, false)

                -- Desenha texto flutuante
                DrawText3D(marker.coords.x, marker.coords.y, marker.coords.z, marker.text)

                if #(playerCoords - marker.coords) < marker.textDistance then
                    -- Exibe notificação personalizada
                    SetTextComponentFormat("STRING")
                    --AddTextComponentString("Pressione [E] para interagir com " .. marker.text)
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                    if IsControlJustReleased(1, 38) then
                        -- Ação quando o jogador interage com o marcador
                        print("Interagiu com: " .. marker.text)
                    end
                end
            end
        end

        -- Processa teleportes
        for _, tp in ipairs(Config.Teleports) do
            if #(playerCoords - tp.clickCoords) < tp.distance then
                -- Desenha marcador de clique para o teleporte
                DrawMarker(1, tp.clickCoords.x, tp.clickCoords.y, tp.clickCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                           1.0, 1.0, 1.0, 255, 255, 255, 255, false, true, 2, nil, nil, false)

                -- Desenha texto flutuante para teleporte
                DrawText3D(tp.clickCoords.x, tp.clickCoords.y, tp.clickCoords.z, tp.text)

                if #(playerCoords - tp.clickCoords) < 1.5 then
                    -- Exibe notificação personalizada
                    SetTextComponentFormat("STRING")
                    AddTextComponentString("Pressione [E] para " .. tp.text)
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)

                    if IsControlJustReleased(1, 38) then
                        -- Teleporta o jogador
                        SetEntityCoords(playerPed, tp.teleportTo.x, tp.teleportTo.y, tp.teleportTo.z, false, false, false, true)
                        print(tp.notifyText)

                        -- Notifica o jogador
                        SetTextComponentFormat("STRING")
                        AddTextComponentString(tp.notifyText)
                        DisplayHelpTextFromStringLabel(0, 0, 2000, -1)
                    end
                end
            end
        end
        
        Citizen.Wait(0)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
end
