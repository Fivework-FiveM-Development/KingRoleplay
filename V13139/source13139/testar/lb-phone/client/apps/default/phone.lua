local CurrentCall = nil
local tmpCallId = nil

RegisterNUICallback('Phone', function(data, cb)
    if data.action == 'getContacts' then
        CB.TriggerServerCallback('phone:phone:getContacts', function(data)
            cb(data)
        end)
    elseif data.action == 'getContact' then
        CB.TriggerServerCallback('phone:phone:getContact', function(data)
            cb(data)
        end, data.number)
    elseif data.action == 'removeContact' then
        CB.TriggerServerCallback('phone:phone:removeContact', function(data)
            cb(data)
        end, data.number)
    elseif data.action == 'toggleBlock' then
        CB.TriggerServerCallback('phone:phone:toggleBlock', function(data)
            cb(data)
        end, data.number, data.blocked)
    elseif data.action == 'toggleFavourite' then
        CB.TriggerServerCallback('phone:phone:toggleFavourite', function(data)
            cb(data)
        end, data.number, data.favourite)
    elseif data.action == 'updateContact' then
        CB.TriggerServerCallback('phone:phone:updateContact', function(data)
            cb(data)
        end, data.data)
    elseif data.action == 'getRecent' then
        CB.TriggerServerCallback('phone:phone:getRecentCalls', function(data)
            cb(data)
        end, data.page)
    elseif data.action == 'clearRecent' then
        CB.TriggerServerCallback('phone:phone:clearRecentCalls', function(data)
            cb(data)
        end, data.page)
    elseif data.action == 'getBlockedNumbers' then
        CB.TriggerServerCallback('phone:phone:getBlockedNumbers', function(data)
            cb(data)
        end, data.page)
    elseif data.action == 'call' then
        tmpCallId = nil
        CB.TriggerServerCallback('phone:phone:call', function(callId, rejectReason)
            if not rejectReason then
                tmpCallId = callId
                Animations.startPhoneCall()
            end

            cb({
                callId = callId,
                rejectReason = rejectReason,
            })
        end, data)
    elseif data.action == 'endCall' then
        CB.TriggerServerCallback('phone:phone:endCall', function()
            cb(true)
        end)
    elseif data.action == 'answerCall' then
        CB.TriggerServerCallback('phone:phone:answerCall', function(data)
            cb(data)
        end, data.callId)
    elseif data.action == 'toggleMute' then
        exports['pma-voice']:setCallMuted(data.toggle)
        cb(true)
    elseif data.action == 'toggleSpeaker' then
        exports['pma-voice']:setLoudSpeaker(data.toggle)
        cb(true)
    elseif data.action == 'saveContact' then
        CB.TriggerServerCallback('phone:phone:saveContact', function(data)
            cb(data)
        end, data.data)
    elseif data.action == 'flipCamera' then
        local value = data.value
        cb(true)
    end
end)

RegisterNetEvent("phone:callFromBooth", function(targetNumber, boothId)
    CB.TriggerServerCallback('phone:phone:callFromBooth', function(callId, rejectReason)
        if not rejectReason then
            tmpCallId = callId
            Animations.startPhoneCallBooth()
            CreateThread(function()
                while tmpCallId do
                    Wait(0)
                    DisableAllControlActions(0)
                    EnableControlAction(0, 249, true)
                    AVA.ShowHelpNotification('Appuyez sur ~INPUT_CELLPHONE_CANCEL~ pour raccrocher')
                end
            end)
            return
        end
        local message = rejectReason == 'USER_BUSY' and 'Le destinataire est occupé' or 'Le destinataire ne répond pas'
        AVA.ShowNotification('~r~' .. message)
    end, targetNumber, boothId)
end)

RegisterNetEvent('phone:phone:updateContact', function()
    SendReactMessage("phone:updateContact")
end)

RegisterNetEvent('phone:phone:incomingCall', function(data)
    tmpCallId = data.callId
    SendReactMessage("phone:incomingCall", data)
end)

RegisterNetEvent('phone:setPhone', function()
    tmpCallId = nil
end)

RegisterNetEvent('phone:phone:connectCall', function(callId, PhoneCall)
    tmpCallId = nil
    PhoneCall.callId = callId
    CurrentCall = PhoneCall

    SendReactMessage("phone:call:connected", callId)
    Animations.startPhoneCall()
    exports['pma-voice']:setCallChannel(callId)

    if CurrentCall.videoCall then
        CAMERA_MODE = 1
        CAMERA_FLIPPED = true
        Animations.openCamera()
    end
end)

RegisterNetEvent('phone:phone:connectCallToBooth', function(callId, PhoneCall)
    tmpCallId = nil
    PhoneCall.callId = callId
    CurrentCall = PhoneCall

    CreateThread(function()
        while CurrentCall do
            Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 249, true)
            AVA.ShowHelpNotification('Appuyez sur ~INPUT_CELLPHONE_CANCEL~ pour raccrocher')
        end
    end)
    exports['pma-voice']:setCallChannel(callId)
end)

RegisterNetEvent('phone:phone:endCallToBooth', function(callId)
    if not ((CurrentCall and CurrentCall.callId == callId) or (tmpCallId == callId)) then
        return print('Bad endCall to Booth', tmpCallId, CurrentCall?.callId, callId)
    end

    tmpCallId = nil

    exports['pma-voice']:setCallChannel(0)
    Animations.endPhoneCallBooth()

    CurrentCall = nil
end)

RegisterNetEvent('phone:phone:endCall', function(callId)
    if not ((CurrentCall and CurrentCall.callId == callId) or (tmpCallId == callId)) then
        return print('Bad endCall', tmpCallId, CurrentCall?.callId, callId)
    end

    tmpCallId = nil
    SendReactMessage("phone:call:endCall", callId)
    exports['pma-voice']:setCallChannel(0)
    Animations.endPhoneCall()
    Animations.closeCamera()

    CAMERA_MODE = nil
    CAMERA_FLIPPED = false
    CurrentCall = nil
end)

RegisterKeyMapping('+use_answercall_key', 'Accepter une appel', 'keyboard', 'RETURN')
RegisterKeyMapping('+use_declinecall_key', 'Refuser l\'appel', 'keyboard', 'BACK')

RegisterCommand('-use_answercall_key', function() end)
RegisterCommand('+use_answercall_key', function()
    if IS_PHONE_OPEN then return end
    if exports[RESOURCE_NAME]:HasMenuOpen() then return end
    if not tmpCallId then return end
    CB.TriggerServerCallback('phone:phone:answerCall', function() end, tmpCallId)
    AVA.ShowNotification('~g~Vous acceptez l\'appel (bind)')
end)

RegisterCommand('-use_declinecall_key', function() end)
RegisterCommand('+use_declinecall_key', function()
    if IS_PHONE_OPEN then return end
    if exports[RESOURCE_NAME]:HasMenuOpen() then return end
    if not tmpCallId then return end
    CB.TriggerServerCallback('phone:phone:endCall', function() end, tmpCallId)
    AVA.ShowNotification('~g~Vous refusez l\'appel')
end)

exports('IsInCall', function()
    return CurrentCall
end)