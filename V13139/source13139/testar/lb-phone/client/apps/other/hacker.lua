local cachedPhone = nil
local cachedProfile = {}

local vehicleList = {}
local vehicleSelected = nil

local inComms = 0
local timeoutAction = {}

local function getVehicleIdToNetworkId(veh)
    return NetworkGetEntityIsNetworked(veh) and NetworkGetNetworkIdFromEntity(veh) or false
end

local function drawLineVehicleToPlayer(entity)
    assert(type(entity) =="number")
    if not DoesEntityExist(entity) then return end

    local ply = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(ply, false)
    local plyIsInVeh = plyVeh ~= 0
    local playerCoords, entityCoords, boneCoords = GetEntityCoords(ply), GetEntityCoords(entity), GetWorldPositionOfEntityBone(ply, 90)

    if plyVeh == entity then return end
    if entity ~= vehicleSelected then
        local shape = StartShapeTestCapsule((plyIsInVeh and (playerCoords + vector3(0.0, 0.0, 1.1)) or (boneCoords + vector3(0.0, 0.0, 0.15))), entityCoords, 2, -1, entity, 7)
        local _, hit, _, _, _, _ = GetShapeTestResult(shape)
        if hit == true or hit == 1 or not IsEntityOnScreen(entity) then return end
    end

    local sameVehicleFromSelected = (vehicleSelected and vehicleSelected == entity) or false
    if sameVehicleFromSelected then
        DrawLine(boneCoords, entityCoords, 126, 66, 245, math.random(120, 255))
    else
        DrawLine(boneCoords, entityCoords, 255, 255, 255, math.random(120, 255))
    end

    table.insert(vehicleList, {
        entityId = entity,
        plate = GetVehicleNumberPlateText(entity),
        modelName = GetEntityArchetypeName(entity) or '?',
        dist = math.floor(#(entityCoords - playerCoords)),
    })
end

local function drawLinePlayerToPlayer(playerTarget)
    assert(type(playerTarget) =="number")
    if not DoesEntityExist(GetPlayerPed(playerTarget)) then return end

    local ply = PlayerPedId()
    local entity = GetPlayerPed(playerTarget)
    local entityCoords, boneCoords = GetEntityCoords(entity), GetWorldPositionOfEntityBone(ply, 90)

    local shape = StartShapeTestCapsule(boneCoords + vector3(0.0, 0.0, 0.15), entityCoords + vector3(0.0, 0.0, 1.0), 2, -1, 0, 7)
    local _, hit, _, _, _, _ = GetShapeTestResult(shape)
    if hit ~= true and hit ~= 1 and IsEntityOnScreen(entity) and IsEntityVisible(entity) then
        DrawLine(boneCoords, entityCoords, 255,  255,  255,  math.random(120, 255))
    end
end

RegisterNUICallback('Hacker', function(data, cb)
    if data.action == 'getHackerProfile' then
        if cachedPhone ~= data.phoneNumber then
            cachedProfile = {}
            cachedPhone = data.phoneNumber
        end
        cb(cachedProfile)
    elseif data.action == 'login' then
        CB.TriggerServerCallback('phone:hacker:login', function(res)
            cachedProfile = res
            cb(res)
        end, data.password)
    elseif data.action == 'getContacts' then
        CB.TriggerServerCallback('phone:hacker:getContacts', function(res)
            cb(res)
        end)
    elseif data.action == 'addContacts' then
        if not data.name or not data.num then cb({}) return end
        CB.TriggerServerCallback('phone:hacker:addContacts', function(res)
            cb(res)
        end, data.name, data.num)
    elseif data.action == 'deleteContacts' then
        if not data.num then cb(nil) return end
        CB.TriggerServerCallback('phone:hacker:deleteContacts', function(res)
            cb(res)
        end, data.num)
    elseif data.action == 'listenContacts' then
        if data.id then
            if inComms > 0 or data.state == false then
                MumbleRemoveVoiceChannelListen(inComms)
                MumbleSetVolumeOverrideByServerId(inComms, -1.0)
                exports['pma-voice']:setEffectSubmixToPlayer(nil, inComms)
                LocalPlayer.state:set('callSpeaker', nil, true)
                inComms = 0
            end
            if data.state and data.num then
                CB.TriggerServerCallback('phone:hacker:targetIsOnairplaneMode', function(isOnairplaneMode)
                    if isOnairplaneMode then return cb(false) end
                    inComms = data.id
                    MumbleAddVoiceChannelListen(data.id)
                    MumbleSetVolumeOverrideByServerId(data.id, (cachedProfile?.settings?.sound or 0.3) + 0.0)
                    exports['pma-voice']:setEffectSubmixToPlayer('radio', inComms)
                    cb(true)
                end, data.num)
            else
                cb(false)
            end
        else
            if inComms > 0 then
                MumbleRemoveVoiceChannelListen(inComms)
                MumbleSetVolumeOverrideByServerId(inComms, -1.0)
                exports['pma-voice']:setEffectSubmixToPlayer(nil, inComms)
                LocalPlayer.state:set('callSpeaker', nil, true)
                inComms = 0
            end
            cb(false)
        end
    elseif data.action == 'wisperContacts' then
        CB.TriggerServerCallback('phone:hacker:wisperContacts', cb, data.num)
    elseif data.action == 'speakerContacts' then
        if inComms > 0 and data.state == true then
            local serverId = GetPlayerServerId(PlayerId())
            LocalPlayer.state:set('callSpeaker', {
                [serverId] = true,
                [inComms] = true
            }, true)
            cb(true)
        else
            LocalPlayer.state:set('callSpeaker', nil, true)
            cb(false)
        end
    elseif data.action == 'getVehicleList' then
        cb(vehicleList)
    elseif data.action == 'vehicleSelected' then
        vehicleSelected = tonumber(data.entityId) or nil
    elseif data.action == 'setVolume' then
        if data.micro or data.sound then
            if not cachedProfile.settings then cachedProfile.settings = {} end
            local oldSettings = AVA.Table.Clone(cachedProfile.settings)

            if data.sound then cachedProfile.settings.sound = tonumber(data.sound) + 0.0 end
            if data.micro then cachedProfile.settings.micro = tonumber(data.micro) + 0.0 end

            if oldSettings == cachedProfile.settings then return end
            if inComms > 0 and cachedProfile.settings.micro then
                MumbleAddVoiceChannelListen(inComms)
                MumbleSetVolumeOverrideByServerId(inComms, cachedProfile.settings.sound + 0.0)
            end

            CB.TriggerServerCallback('phone:hacker:updateSettings', cb(cachedProfile.settings), cachedProfile.settings)
        end
    elseif data.action == 'unlockVehicle' then
        CB.TriggerServerCallback('phone:hacker:unlockVehicle', function(res)
            cb(res)
        end, getVehicleIdToNetworkId(vehicleSelected))
    elseif data.action == 'lockVehicle' then
        CB.TriggerServerCallback('phone:hacker:lockVehicle', function(res)
            cb(res)
        end, getVehicleIdToNetworkId(vehicleSelected))
    elseif data.action == 'startVehicle' then
        CB.TriggerServerCallback('phone:hacker:startVehicle', function(res)
            cb(res)
        end, getVehicleIdToNetworkId(vehicleSelected))
    elseif data.action == 'openVehicleDoors' then
        if timeoutAction[data.action] then return cb({success = false, reason = 'Vous faites ça trop vite !'}) end
        timeoutAction[data.action] = true
        SetTimeout(1000, function() timeoutAction[data.action] = nil end)

        local numberOfDoors = GetNumberOfVehicleDoors(vehicleSelected)
        if numberOfDoors <= 0 then return cb({success = false, reason = 'Pas de porte.'}) end
        local lock = GetVehicleDoorAngleRatio(vehicleSelected, 0) < 0.1
        local tmpDoors = numberOfDoors
        local i = 0
        while tmpDoors > 0 do
            if GetIsDoorValid(vehicleSelected, i) then
                tmpDoors = tmpDoors - 1
                if lock then
                    TriggerServerEvent('ava:vehicle:manageSingleDoor', NetworkGetNetworkIdFromEntity(vehicleSelected), i, true, true)
                else
                    TriggerServerEvent('ava:vehicle:manageSingleDoor', NetworkGetNetworkIdFromEntity(vehicleSelected), i, false, true)
                end
            end
            i = i + 1
        end
        cb({success = true})
    elseif data.action == 'alarmVehicle' then
        CB.TriggerServerCallback('phone:hacker:alarmVehicle', function(res)
            cb(res)
        end, getVehicleIdToNetworkId(vehicleSelected))
    elseif data.action == 'killVehicle' then
        if timeoutAction[data.action] then return cb({success = false, reason = 'Vous faites ça trop vite !'}) end
        timeoutAction[data.action] = true
        SetTimeout(60000, function() timeoutAction[data.action] = nil end)

        CB.TriggerServerCallback('phone:hacker:killVehicle', function(res)
            cb(res)
        end, getVehicleIdToNetworkId(vehicleSelected))
    elseif data.action == 'explodeVehicle' then
        if timeoutAction[data.action] then return cb({success = false, reason = 'Vous faites ça trop vite !'}) end
        timeoutAction[data.action] = true
        SetTimeout(60000, function() timeoutAction[data.action] = nil end)

        CB.TriggerServerCallback('phone:hacker:explodeVehicle', function(res)
            cb(res)
        end, getVehicleIdToNetworkId(vehicleSelected))
    elseif data.action == 'sendNotification' then
        if not data.notification or not data.target then return cb(false) end
        CB.TriggerServerCallback('phone:hacker:sendNotification', function(res)
            cb(res)
        end, data.notification, data.target)
    elseif data.action == 'logout' then
        cachedProfile = {}
        SendReactMessage('Hacker:logout')
    elseif data.action == 'cancelCall' then
        if inComms > 0 then
            MumbleRemoveVoiceChannelListen(inComms)
            MumbleSetVolumeOverrideByServerId(inComms, -1.0)
            exports['pma-voice']:setEffectSubmixToPlayer(nil, inComms)
            LocalPlayer.state:set('callSpeaker', nil, true)
        end

        inComms = 0
        TriggerServerEvent('phone:hacker:stopWisperContacts')
    end
end)

CreateThread(function()
    repeat Wait(1000) until AVA
    if IS_FA then return end
    local lastSend = GetGameTimer()

    while true do
        local curWait = 1000

        if IS_PHONE_OPEN and PHONE_IS_UNLOCK and CURRENT_APP and CURRENT_APP:lower() == 'hacker' and cachedProfile?.haveAccess then
            local ply = PlayerPedId()
            local playerCoords = GetEntityCoords(ply)
            local maxDist = 50.0

            vehicleList = {}
            for _, vehicle in pairs(GetGamePool('CVehicle')) do
                local targetCoords = GetEntityCoords(vehicle)
                if #(targetCoords - playerCoords) < maxDist and DoesEntityExist(vehicle) and (AVA.Math.Round(GetVehicleEngineHealth(vehicle), 1) / 1000) > 0 and IsEntityVisible(vehicle) then
                    drawLineVehicleToPlayer(vehicle)
                end
            end

            for _, player in pairs(GetActivePlayers()) do
                local targetCoords = GetEntityCoords(GetPlayerPed(player))
                local playerTarget = GetPlayerPed(player)
                if playerTarget and #(targetCoords - playerCoords) < maxDist and playerTarget ~= ply and GetVehiclePedIsIn(playerTarget, false) == 0 and IsEntityVisible(playerTarget) then
                    drawLinePlayerToPlayer(player)
                end
            end

            if GetGameTimer() - lastSend > 500 then
                lastSend = GetGameTimer()
                SendReactMessage('Hacker:getVehicleList', vehicleList)

                if vehicleSelected and (not DoesEntityExist(vehicleSelected)) or (DoesEntityExist(vehicleSelected) and (#(GetEntityCoords(vehicleSelected) - playerCoords) > maxDist)) then
                    vehicleSelected = nil
                end
            end

            curWait = 0
        end
        Wait(curWait)
    end
end)

RegisterNetEvent('ava:phone:hacker:logout', function()
    cachedProfile = {}
    SendReactMessage('Hacker:logout')
end)