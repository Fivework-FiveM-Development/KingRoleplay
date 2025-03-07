HAS_NUI_LOADED = false
IS_PHONE_OPEN = false
HAS_PHONE = false
PHONE_IS_UNLOCK = false
CURRENT_APP = nil

RegisterNuiCallback('phoneState', function(data, cb)
    CURRENT_APP = data.app
    PHONE_IS_UNLOCK = data.unlocked
    cb(true)
end)

AddEventHandler('ava:ui:permissionchanged', function()
    SendReactMessage('phone:staff', AVA.IsMod())
end)

CreateThread(function()
    repeat
        Wait(0)
    until AVA
    SendReactMessage('phone:staff', AVA.IsMod())
end)

RegisterNUICallback('getPhoneData', function(data, cb)
    HAS_NUI_LOADED = true

    local file = LoadResourceFile(GetCurrentResourceName(), 'config/config.json')

    for index, value in pairs(json.decode(file)) do
        Config[index] = value
    end

    SendReactMessage('phone:setConfig', Config)
    if HAS_PHONE then
        SendReactMessage('phone:setPhoneData', HAS_PHONE)
    end

    cb(true)
end)
-- S4NA LEAKS
RegisterNetEvent('ava:phone:receiveAddonsApps', function(addonApps)
    local apps = {}
    for index, value in pairs(Config.apps or {}) do
        if not value.addon then
            apps[index] = value
        end
    end
    for index, value in pairs(addonApps) do
        apps[index] = value
    end
    Config.apps = apps
    SendReactMessage('phone:setConfig', Config)
end)

RegisterNetEvent('ava:phone:setSettings', function(settings)
    assert(type(settings) == "table")
    SendReactMessage('phone:setConfig', settings)
end)

RegisterNUICallback('finishedSetup', function(data, cb)
    TriggerServerEvent('phone:finishedSetup', data)
    cb(true)
end)

RegisterNUICallback('setPhoneName', function(data, cb)
    TriggerServerEvent('phone:setName', data)
    cb(true)
end)

RegisterNUICallback('setSettings', function(data, cb)
    TriggerServerEvent('phone:setSettings', data)
    cb(true)
end)

RegisterNUICallback('exitFocus', function(data, cb)
    exports[GetCurrentResourceName()]:ToggleDisabled()
    cb(true)
end)

RegisterNUICallback('getLocales', function(data, cb)
    cb(Config.Locales)
end)

RegisterNetEvent('phone:openPhone', function(toggle)
    if not exports[RESOURCE_NAME]:IsPhoneAllowed() then
        return
    end
    exports[GetCurrentResourceName()]:ToggleOpen()
end)

exports('ToggleOpen', function()
    if IS_PHONE_OPEN then return end
    if not HAS_NUI_LOADED then return end
    if not HAS_PHONE then return end
    IS_PHONE_OPEN = true
    TOGGLE_INPUT = true
    Animations.openPhone()
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    SendReactMessage('togglePhone', true)
    if GetVehiclePedIsIn(PlayerPedId()) == 0 then
        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
    end
end)

exports('IsOpen', function()
    return IS_PHONE_OPEN
end)

exports('ToggleDisabled', function()
    if not IS_PHONE_OPEN then return end
    IS_PHONE_OPEN = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    Animations.closePhone()
    SendReactMessage('closePhone')
end)

SendReactMessage = function(action, data)
    SendNUIMessage({
        action = action,
        data = data,
    })
end

RegisterNetEvent('phone:setPhone', function(data, addonApps)
    if addonApps then
        TriggerEvent('ava:phone:receiveAddonsApps', addonApps)
    end
    if not data then
        exports[GetCurrentResourceName()]:ToggleDisabled()
    end

    if data and not data?.settings?.locale then error('Missing locale data in setPhone') return end

    HAS_PHONE = data
    if not HAS_NUI_LOADED then return end
    SendReactMessage('phone:setPhoneData', data)
end)

RegisterKeyMapping('phone', 'Ouvrir le téléphone', 'keyboard', 'K')
RegisterCommand('phone', function()
    if not exports[RESOURCE_NAME]:IsPhoneAllowed() then
        return
    end
    if exports[RESOURCE_NAME]:HasFocus() then
        return
    end
    if IS_PHONE_OPEN then
        exports[GetCurrentResourceName()]:ToggleDisabled()
    else
        if IsEntityInWater(PlayerPedId()) then return end
        if IsPauseMenuActive() then return end
        exports[GetCurrentResourceName()]:ToggleOpen()
    end
end)