QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}
local loaded = false

local function createProperty(property)
	PropertiesTable[property.property_id] = Property:new(property)
end
RegisterNetEvent('ps-housing:client:addProperty', createProperty)

RegisterNetEvent('ps-housing:client:removeProperty', function (property_id)
	local property = Property.Get(property_id)

	if property then
		property:RemoveProperty(true)
	end

	PropertiesTable[property_id] = nil
end)

function InitialiseProperties(properties)
    if loaded then return end
    Debug("Initialising properties")
    PlayerData = QBCore.Functions.GetPlayerData()

    for k, v in pairs(Config.Apartments) do
        ApartmentsTable[k] = Apartment:new(v)
    end

	if not properties then
    	properties = lib.callback.await('ps-housing:server:requestProperties')
	end
	
    for k, v in pairs(properties) do
        createProperty(v.propertyData)
    end

    TriggerEvent("ps-housing:client:initialisedProperties")

    Debug("Initialised properties")
    loaded = true
end
AddEventHandler("QBCore:Client:OnPlayerLoaded", InitialiseProperties)
RegisterNetEvent('ps-housing:client:initialiseProperties', InitialiseProperties)

-- AddEventHandler("onResourceStart", function(resourceName) -- Used for when the resource is restarted while in game
-- 	if (GetCurrentResourceName() == resourceName) then
--         InitialiseProperties()
-- 	end
-- end)

if GetResourceState('qbx_properties') == 'started' then
    local data = {}
    for k, v in pairs(Config.Apartments) do
        data[#data +1] = {
            label = v.label,
            description = 'Luxury Apartments!',
            enter = vec3(v.door.x, v.door.y, v.door.z),
            id = k
        }
    end
    TriggerEvent('ps-housing:setApartments', data)
end

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('ps-housing:client:setupSpawnUI', function(cData)
    DoScreenFadeOut(1000)
    local result = lib.callback.await('ps-housing:cb:GetOwnedApartment', source, cData.citizenid)
    if result then
        TriggerEvent('qb-spawn:client:setupSpawns', cData, false, nil)
        TriggerEvent('qb-spawn:client:openUI', true)
    else
        if Config.StartingApartment then
            TriggerEvent('qb-spawn:client:setupSpawns', cData, true, Config.Apartments)
            TriggerEvent('qb-spawn:client:openUI', true)
        else
            TriggerEvent('qb-spawn:client:setupSpawns', cData, false, nil)
            TriggerEvent('qb-spawn:client:openUI', true)
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		if Modeler.IsMenuActive then
			Modeler:CloseMenu()
		end

		for k, v in pairs(PropertiesTable) do
			v:RemoveProperty()
		end

        for k, v in pairs(ApartmentsTable) do
            v:RemoveApartment()
        end
	end
end)

exports('GetProperties', function()
    return PropertiesTable
end)

exports('GetProperty', function(property_id)
    return Property.Get(property_id)
end)

exports('GetApartments', function()
    return ApartmentsTable
end)

exports('GetApartment', function(apartment)
    return Apartment.Get(apartment)
end)

exports('GetShells', function()
    return Config.Shells
end)


lib.callback.register('ps-housing:cb:confirmPurchase', function(amount, street, id)
    return lib.alertDialog({
        header = 'Purchase Confirmation',
        content = 'Are you sure you want to purchase '..street..' ' .. id .. ' for $' .. amount .. '?',
        centered = true,
        cancel = true,
        labels = {
            confirm = "Purchase",
            cancel = "Não"
        }
    })
end)

lib.callback.register('ps-housing:cb:confirmRaid', function(street, id)
    return lib.alertDialog({
        header = 'Invadir',
        content = 'Você quer invadir? '..street..' ' .. id .. '?',
        centered = true,
        cancel = true,
        labels = {
            confirm = "Invadir",
            cancel = "Não"
        }
    })
end)

lib.callback.register('ps-housing:cb:ringDoorbell', function()
    return lib.alertDialog({
        header = 'Tocar a campainha.',
        content = 'Você não tem a chave para esta propriedade, gostaria de tocar a campainha?',
        centered = true,
        cancel = true,
        labels = {
            confirm = "Tocar",
            cancel = "Não"
        }
    })
end)

lib.callback.register('ps-housing:cb:showcase', function()
    return lib.alertDialog({
        header = 'Conhecer Propriedade',
        content = 'Você realmente quer conhecer esta propriedade?',
        centered = true,
        cancel = true,
        labels = {
            confirm = "Sim",
            cancel = "Não"
        }
    })
end)
