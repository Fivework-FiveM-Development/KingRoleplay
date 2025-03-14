local npcTable = {}

lib.addCommand('npc', {
    help = 'Abre o menu de criação de NPC',
    restricted = 'group.admin'
}, function(source, args, raw)
    lib.callback.await('mri_Qnpc:client:npcMenuList', source, false)
end)

AddEventHandler("insertData")
RegisterNetEvent("insertData", function(coords, model, data, heading)
    print("insertData", coords, model, data, heading)
    -- verificar se data.name existe antes na tabela npcTable
    for i = 1, #npcTable do
        if string.lower(npcTable[i].name) == string.lower(data.name) then
            print("NPC ".. data.name.. " já existe, substituindo pelo novo colocado.")
            npcTable[i] = {
                name = data.name,
                hash = model,
                event = data.event,
                coords = coords,
                heading = heading,
                animDict = data.animDict,
                animName = data.animName,
                useOxTarget = data.useOxTarget,
                job = data.job,
                grade = data.grade,
                oxTargetLabel = data.oxTargetLabel,
                useDrawText = data.useDrawText,
                drawTextKey = data.drawTextKey,
                scullyEmote = data.scullyEmote,
                npcDialog = data.npcDialog
            }
            return SaveNPCData()
        end
    end

    table.insert(npcTable, {
        name = data.name,
        hash = model,
        event = data.event,
        coords = coords,
        heading = heading,
        animDict = data.animDict,
        animName = data.animName,
        useOxTarget = data.useOxTarget,
        job = data.job,
        grade = data.grade,
        oxTargetLabel = data.oxTargetLabel,
        useDrawText = data.useDrawText,
        drawTextKey = data.drawTextKey,
        scullyEmote = data.scullyEmote,
        npcDialog = data.npcDialog
    })
    SaveNPCData()
end)

AddEventHandler("npcDelete")
RegisterNetEvent("npcDelete", function(name)
    for i = #npcTable, 1, -1 do
        if string.lower(npcTable[i].name) == string.lower(name) then
            local npcName = npcTable[i].name
            table.remove(npcTable, i)
            SaveNPCData()
            TriggerClientEvent('deleteNPCServer', -1, npcName)
            break
        end
    end
end)

function SaveNPCData()
    local jsonData = json.encode(npcTable)
    SaveResourceFile(GetCurrentResourceName(), "npcData.json", jsonData, -1)
    lib.callback.await('npcDeleteAll', source, npcTable)
    TriggerClientEvent('NPCresourceStart', -1, npcTable)
end

function LoadNPCData()
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "npcData.json")
    if loadFile then
        npcTable = json.decode(loadFile)
    end
end

lib.callback.register('npcGetAll', function(source)
    return npcTable
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(2000)
        LoadNPCData()
        Wait(200)
        TriggerClientEvent('NPCresourceStart', -1, npcTable)
    end  
end)

-- AddEventHandler('onResourceStop', function(resourceName)
--     if GetCurrentResourceName() == resourceName then
--         npcTable = {}
--     end
-- end)

-- AddEventHandler("playerJoining", function(playerId, reason)
--     LoadNPCData()
--     Wait(200)
--     TriggerClientEvent('NPCresourceStart', playerId, npcTable)
-- end)