local Config = lib.require('config')

local isHired, droppingOff, showText = false, false, false
local CRATE_OBJECT, cargoPed, DropOffZone, jobBlip, startPoint, pedInteract
local routeData = {}

local CARGO_BLIP = AddBlipForCoord(Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z)
SetBlipSprite(CARGO_BLIP, 615)
SetBlipDisplay(CARGO_BLIP, 4)
SetBlipScale(CARGO_BLIP, 0.8)
SetBlipAsShortRange(CARGO_BLIP, true)
SetBlipColour(CARGO_BLIP, 52)
BeginTextCommandSetBlipName("STRING")
AddTextComponentSubstringPlayerName("Transportador")
EndTextCommandSetBlipName(CARGO_BLIP)

local function showCargoScaleform(bool)
    local scaleform = lib.requestScaleformMovie('MIDSIZED_MESSAGE', 1000)
    local info = Config.DeliveryInfo
    BeginScaleformMovieMethod(scaleform, 'SHOW_COND_SHARD_MESSAGE')
    if bool then info = Config.ReturnInfo end

    PushScaleformMovieMethodParameterString(info.title)
    PushScaleformMovieMethodParameterString(info.msg)
    EndScaleformMovieMethod()
    PlaySoundFrontend(-1, info.audioName, info.audioRef, 0)
    local sec = info.sec
    while sec > 0 do
        Wait(1)
        sec -= 0.01
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end
    SetScaleformMovieAsNoLongerNeeded(scaleform)
end

local function finishRoute()
    if not isHired then return end
    local ped = cache.ped
    local success = lib.callback.await('randol_cargo:server:finishRoute', false)
    if success then
        if DropOffZone then DropOffZone:remove() end
        if DoesBlipExist(jobBlip) then RemoveBlip(jobBlip) end
        isHired = false
        CRATE_OBJECT = nil
        table.wipe(routeData)
    end
end

local function interactContext()
    lib.registerContext({
        id = 'interact_cargo',
        title = "Transporte de carga",
        options = {
            {
                title = "Inicie a entrega de carga",
                icon = "fa-solid fa-truck-moving",
                disabled = isHired,
                onSelect = function()
                    if IsAnyVehicleNearPoint(Config.VehicleSpawn.x, Config.VehicleSpawn.y, Config.VehicleSpawn.z, 5.0) then 
                        DoNotification('A vehicle is blocking the spawn.', 'error') 
                        return 
                    end
                    local success = lib.callback.await('randol_cargo:server:beginRoute', false)
                end,
            },
            {
                title = "Finalizar a entrega",
                icon = "fa-solid fa-clipboard-check",
                disabled = not isHired,
                onSelect = function()
                    finishRoute()
                end,
            },
        }
    })
    lib.showContext('interact_cargo')
end

local function nearZone(point)
    DrawMarker(1, point.coords.x, point.coords.y, point.coords.z - 1, 0, 0, 0, 0, 0, 0, 6.0, 6.0, 1.5, 79, 194, 247, 165, 0, 0, 0,0)
    
    if point.isClosest and point.currentDistance <= 4 then
        if not showText then
            showText = true
            lib.showTextUI('**E** - Entregar carga', {position = "right-center"})
        end
        if isHired and cache.vehicle and IsEntityAttachedToEntity(cache.vehicle, CRATE_OBJECT) then
            if IsControlJustPressed(0, 38) and not droppingOff then
                droppingOff = true
                lib.hideTextUI()
                if lib.progressCircle({
                    duration = 5000,
                    position = 'bottom',
                    label = "Descarregando a entrega...",
                    useWhileDead = true,
                    canCancel = false,
                    disable = { move = true, car = true, mouse = false, combat = true, },
                }) then
                    DropOffZone:remove()
                    DropOffZone = nil
                    RemoveBlip(jobBlip)
                    NetworkFadeOutEntity(CRATE_OBJECT, 0, 1)
                    Wait(500)
                    local success = lib.callback.await('randol_cargo:server:updateRoute', false, NetworkGetNetworkIdFromEntity(CRATE_OBJECT))
                    if success then
                        droppingOff = false
                        showCargoScaleform(true)
                    end
                end
            end
        end
    elseif showText then
        showText = false
        lib.hideTextUI()
    end
end

local function setRoute(route)
    jobBlip = AddBlipForCoord(route.x, route.y, route.z)
    SetBlipSprite(jobBlip, 615)
    SetBlipDisplay(jobBlip, 4)
    SetBlipScale(jobBlip, 1.0)
    SetBlipFlashes(jobBlip, false)
    SetBlipAsShortRange(jobBlip, true)
    SetBlipColour(jobBlip, 3)
    SetBlipRoute(jobBlip, true)
    SetBlipRouteColour(jobBlip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Ponto de entrega")
    EndTextCommandSetBlipName(jobBlip)

    DropOffZone = lib.points.new({ coords = vec3(route.x, route.y, route.z), distance = 30, nearby = nearZone, })
    isHired = true
    showCargoScaleform()
end

local function yeetPed()
    if DoesEntityExist(cargoPed) then
        DeleteEntity(cargoPed)
        cargoPed = nil
        if pedInteract then
            pedInteract:remove()
            pedInteract = nil
        end
    end
end

local function spawnPed()
    if DoesEntityExist(cargoPed) then return end

    if Config.talkNPC then
    cargoPed = exports['rep-talkNPC']:CreateNPC({
        npc = Config.Ped,
        coords = vector3(Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z),
        heading = Config.PedCoords.w,
        name = 'Seu Zé',
        tag = 'TRANSPORTADOR',
        animScenario = 'WORLD_HUMAN_CLIPBOARD',
        position = "Empurra muita carga",
        color = "green",
        startMSG = 'Ei, você aí, tá precisando de emprego?'
    }, {
        [1] = {
            label = "Como funciona esse trabalho?",
            shouldClose = false,
            action = function()
                exports['rep-talkNPC']:changeDialog("🤔 Hm... **Você não me é estranho**.  \nDe toda forma, prazer, sou o 😃**José Henrique**!  \nMas pode me chamar só de Seu Zé.  \nVocê nunca trabalhou de 🚚📦 entregador por aqui?   \n**É fácil demais, só dirigir, entregar e voltar pra receber o pagamento**. 💸  \nAinda tá aqui? Vai trabalhar! 💼👊", 
                    {
                        [1] = {
                            label = "Entendido. Vamos trabalhar!",
                            action = function()
                                if not isHired then
                                    if IsAnyVehicleNearPoint(Config.VehicleSpawn.x, Config.VehicleSpawn.y, Config.VehicleSpawn.z, 5.0) then 
                                        DoNotification('Um veículo está ocupando a vaga. Por favor, espere.', 'error') 
                                        return 
                                    end
                                    local success = lib.callback.await('randol_cargo:server:beginRoute', false)
                                    TriggerEvent('rep-talkNPC:client:close')
                                else
                                    exports['rep-talkNPC']:updateMessage("Você já está trabalhando como transportador.")
                                end
                            end
                        },
                        [2] = {
                            label = "Ah sim... Talvez mais tarde.",
                            shouldClose = true,
                            action = function()
                            end
                        }
                    })
            end
        },
        [2] = {
            label = "Trabalhar/Finalizar",
            shouldClose = true,
            action = function()
                if not isHired then
                    if IsAnyVehicleNearPoint(Config.VehicleSpawn.x, Config.VehicleSpawn.y, Config.VehicleSpawn.z, 5.0) then 
                        DoNotification('Um veículo está ocupando a vaga. Por favor, espere.', 'error') 
                        return 
                    end
                    local success = lib.callback.await('randol_cargo:server:beginRoute', false)
                else
                    finishRoute()
                end
            end
        },
        [3] = {
            label = "Talvez outra hora...",
            shouldClose = true,
            action = function()
            end
        }
    })
    else
        lib.requestModel(joaat(Config.Ped), 5000)
        cargoPed = CreatePed(0, Config.Ped, Config.PedCoords, false, false)
        SetEntityAsMissionEntity(cargoPed, true, true)
        SetPedFleeAttributes(cargoPed, 0, 0)
        SetBlockingOfNonTemporaryEvents(cargoPed, true)
        SetEntityInvincible(cargoPed, true)
        FreezeEntityPosition(cargoPed, true)
        SetModelAsNoLongerNeeded(joaat(Config.Ped))

        if Config.Target then
            exports['qb-target']:AddTargetEntity(cargoPed, { 
                options = {
                    { 
                        icon = "fa-solid fa-truck-moving",
                        label = "Inicie a entrega de carga",
                        canInteract = function() return not isHired end,
                        action = function()
                            if IsAnyVehicleNearPoint(Config.VehicleSpawn.x, Config.VehicleSpawn.y, Config.VehicleSpawn.z, 5.0) then 
                                DoNotification('A vehicle is blocking the spawn.', 'error') 
                                return 
                            end
                            local success = lib.callback.await('randol_cargo:server:beginRoute', false)
                        end,
                    },
                    { 
                        icon = "fa-solid fa-clipboard-check",
                        label = "Finalizar a entrega",
                        canInteract = function() return isHired end,
                        action = function()
                            finishRoute()
                        end,
                    },
                }, 
                distance = 1.5, 
            })
        else
            pedInteract = lib.zones.box({
                coords = vec3(Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z+0.5), 
                size = vector3(2, 2, 2),
                rotation = GetEntityHeading(cargoPed),
                debug = false,
                onEnter = function()
                    lib.showTextUI('**E** - Interagir', {position = "right-center"})
                end,
                onExit = function()
                    lib.hideTextUI()
                end,
                inside = function()
                    if IsControlJustPressed(0, 38) then
                        interactContext()
                    end
                end,
            })
        end
    end
end

RegisterNetEvent('randol_cargo:client:startRoute', function(data, vehNet, crateNet)
    if GetInvokingResource() then return end
    routeData = data
    
    local veh = lib.waitFor(function()
        if NetworkDoesEntityExistWithNetworkId(vehNet) then
            return NetToVeh(vehNet)
        end
    end, 'Could not load entity in time.', 1000)
    
    local rnd = tostring(math.random(1000, 9999))
    CRATE_OBJECT = NetworkGetEntityFromNetworkId(crateNet)

    SetVehicleNumberPlateText(veh, "CARG"..rnd)
    handleVehicleKeys(veh)
    SetVehicleEngineOn(veh, true, true)
    SetVehicleExtra(veh, 2, true)
    SetVehicleExtra(veh, 3, true)

    if Config.Fuel.enable then
        exports[Config.Fuel.script]:SetFuel(veh, 100.0)
    else
        Entity(veh).state.fuel = 100
    end

    if NetworkGetEntityOwner(CRATE_OBJECT) ~= cache.playerId then
        while NetworkGetEntityOwner(CRATE_OBJECT) ~= cache.playerId do -- I'm not proud of it either, trust me.
            NetworkRequestControlOfEntity(CRATE_OBJECT)
            Wait(10)
        end
    end

    local x, y, z = routeData.attach.x, routeData.attach.y, routeData.attach.z
    AttachEntityToEntity(CRATE_OBJECT, veh, GetEntityBoneIndexByName(veh, 'bodyshell'), x, y, z, 0, 0, 0, 1, 1, 0, 1, 0, 1)
    FreezeEntityPosition(CRATE_OBJECT, true)
    setRoute(routeData.route)
end)

local function createStartPoint()
    startPoint = lib.points.new({
        coords = Config.PedCoords.xyz,
        distance = 30,
        onEnter = spawnPed,
        onExit = yeetPed,
    })
end

function OnPlayerLoaded()
    createStartPoint()
end

function OnPlayerUnload()
    if DoesEntityExist(cargoPed) then DeleteEntity(cargoPed) end
    if DoesBlipExist(jobBlip) then RemoveBlip(jobBlip) end
    if startPoint then startPoint:remove() end
    if DropOffZone then DropOffZone:remove() end
    if isHired then isHired = false end
    table.wipe(routeData)
end

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource or not hasPlyLoaded() then return end
    createStartPoint()
end)

AddEventHandler('onResourceStop', function(resourceName) 
    if GetCurrentResourceName() == resourceName then
        if DropOffZone then DropOffZone:remove() end
        if DoesEntityExist(cargoPed) then DeleteEntity(cargoPed) end
    end 
end)
