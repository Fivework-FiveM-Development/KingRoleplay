
RegisterNUICallback('News', function(data, cb)
    AVA.TriggerServerCallback('ava:ads:getAds', function(data)
        cb(data)
    end, data.query or data.page)
end)