local loops = {}

CreateThread(function()
    if not Entity(PlayerPedId()).state.recordingPeerId then return end
    Entity(PlayerPedId()).state:set('recordingPeerId', nil, true)
end)

AddStateBagChangeHandler('recordingPeerId', nil, function(bagName, _, value)
	local entity = GetEntityFromStateBagName(bagName)
	if entity == 0 then return end
    if entity == PlayerPedId() then return end

    if loops[entity] and loops[entity] ~= value then
        SendReactMessage('voice:leaveChannel', loops[entity])
    end
    loops[entity] = value

    if not value then return end
    CreateThread(function()
        SendReactMessage('voice:joinChannel', {
            volume = 0.0,
            channel = loops[entity],
        })

        while loops[entity] and DoesEntityExist(entity) do
            local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity))
            local volume = 1.0 - math.min(dist / 5, 1.0)

            SendReactMessage('voice:setVolume', {
                volume = volume,
                channel = loops[entity],
            })

            Wait(100)
        end
    end)
end)