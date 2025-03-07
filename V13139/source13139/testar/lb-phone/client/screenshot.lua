RegisterNetEvent('phone:takeScreenshot', function()
    SendReactMessage('Phone:GetScreenshot', {})
end)

RegisterNUICallback('Phone:ScreenshotCB', function(data, cb)
    local url = data.url
    local time = GetNetworkTime()
    Entity(PlayerPedId()).state:set('phoneScreenshot', {
        time = time,
        url = url,
    }, true)
    SetTimeout(5000, function()
        local phoneScreenshot = Entity(PlayerPedId()).state.phoneScreenshot
        if phoneScreenshot and phoneScreenshot.time == time then
            Entity(PlayerPedId()).state:set('phoneScreenshot', nil, true)
        end
    end)
    cb('ok')
end)