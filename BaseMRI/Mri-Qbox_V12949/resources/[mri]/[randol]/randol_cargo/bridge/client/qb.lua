if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    OnPlayerLoaded()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    OnPlayerUnload()
end)

function handleVehicleKeys(veh)
    local plate = GetVehicleNumberPlateText(veh)
    -- TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
end

function hasPlyLoaded()
    return LocalPlayer.state.isLoggedIn
end

function DoNotification(text, nType)
    QBCore.Functions.Notify(text, nType)
end
