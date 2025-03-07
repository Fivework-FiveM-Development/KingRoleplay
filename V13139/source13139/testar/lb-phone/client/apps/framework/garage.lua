RegisterNUICallback("Garage", function(data, cb)
    local action = data.action

    if action == "getVehicles" then
        AVA.TriggerServerCallback("ava:vehicle:getMyVehicles", function(results)
            local xVehiclesData = {}
            for _, xVehicleData in pairs(results) do
                local modelHash = GetHashKey(xVehicleData.modelName)
                if IsThisModelABike(modelHash) then
                    xVehicleData.type = 'bike'
                elseif IsThisModelABoat(modelHash) then
                    xVehicleData.type = 'boat'
                elseif IsThisModelATrain(modelHash) then
                    xVehicleData.type = 'train'
                elseif IsThisModelACar(modelHash) then
                    xVehicleData.type = 'car'
                elseif IsThisModelAPlane(modelHash) then
                    xVehicleData.type = 'plane'
                else
                    xVehicleData.type = 'car'
                end
                table.insert(xVehiclesData, xVehicleData)
            end
            cb(xVehiclesData)
        end)
    elseif action == "setWaypoint" then
        TriggerServerEvent('ava:vehicle:locate', data.vehicleId)
        cb('ok')
    elseif action == "sell" then
        exports[GetCurrentResourceName()]:ToggleDisabled()
        TriggerEvent('ava:vehicle:sell', data.vehicleId, data.toGroup)
        cb('ok')
    elseif action == 'rename' then
        TriggerServerEvent('ava:action:garage:updateVehicleName', tonumber(data.vehicleId), data.newName)
        cb('ok')
    end
end)