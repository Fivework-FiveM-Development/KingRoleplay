
RegisterNUICallback('InstaPic', function(data, cb)
    if data.action == 'isLoggedIn' then
        CB.TriggerServerCallback('phone:instapic:isLoggedIn', function(data)
            cb(data)
        end)
    elseif data.action == 'getPost' then
        CB.TriggerServerCallback('phone:instapic:getPost', function(data)
            cb(data)
        end, data.id)
    elseif data.action == 'getPosts' then
        CB.TriggerServerCallback('phone:instapic:getPosts', function(data)
            cb(data)
        end, data.filters, data.page)
    elseif data.action == 'getProfile' then
        CB.TriggerServerCallback('phone:instapic:getProfile', function(data)
            cb(data)
        end, data.username)
    elseif data.action == 'getComments' then
        CB.TriggerServerCallback('phone:instapic:getComments', function(data)
            cb(data)
        end, data.postId, data.page)
    elseif data.action == 'logIn' then
        CB.TriggerServerCallback('phone:instapic:logIn', function(data)
            cb(data)
        end, data.username, data.password)
    elseif data.action == 'createAccount' then
        CB.TriggerServerCallback('phone:instapic:createAccount', function(data)
            cb(data)
        end, data.name, data.username, data.password)
    elseif data.action == 'getNotifications' then
        CB.TriggerServerCallback('phone:instapic:getNotifications', function(data)
            cb(data)
        end, data.page)
    elseif data.action == 'toggleFollow' then
        CB.TriggerServerCallback('phone:instapic:toggleFollow', function(data)
            cb(data)
        end, data.data.username, data.data.following)
    elseif data.action == 'updateProfile' then
        CB.TriggerServerCallback('phone:instapic:updateProfile', function(data)
            cb(data)
        end, data.data.name, data.data.bio, data.data.avatar)
    elseif data.action == 'signOut' then
        CB.TriggerServerCallback('phone:instapic:signOut', function(data)
            cb(data)
        end)
    elseif data.action == 'viewLive' then
        CB.TriggerServerCallback('phone:instapic:viewLive', function(data)
            cb(data)
        end, data.username)
    elseif data.action == 'getMessages' then
        CB.TriggerServerCallback('phone:instapic:getMessages', function(data)
            cb(data)
        end, data.username, data.page)
    elseif data.action == 'getRecentMessages' then
        CB.TriggerServerCallback('phone:instapic:getRecentMessages', function(data)
            cb(data)
        end, data.page)
    elseif data.action == 'getLives' then
        CB.TriggerServerCallback('phone:instapic:getLives', function(data)
            cb(data)
        end, data)
    elseif data.action == 'deletePost' then
        CB.TriggerServerCallback('phone:instapic:deletePost', function(data)
            cb(data)
        end, data.id)
    elseif data.action == 'postComment' then
        CB.TriggerServerCallback('phone:instapic:postComment', function(data)
            cb(data)
        end, data.data.postId, data.data.comment)
    elseif data.action == 'toggleLike' then
        CB.TriggerServerCallback('phone:instapic:toggleLike', function(data)
            cb(data)
        end, data.data.postId, data.data.toggle, data.data.isComment)
    elseif data.action == 'search' then
        CB.TriggerServerCallback('phone:instapic:search', function(data)
            cb(data)
        end, data.query)
    elseif data.action == 'endLive' then
        CB.TriggerServerCallback('phone:instapic:endLive', function(data)
            CAMERA_MODE = nil
            CAMERA_FLIPPED = false
            Animations.closeCamera()

            cb(data)
        end, data)
    elseif data.action == 'newPost' then
        CB.TriggerServerCallback('phone:instapic:createPost', function(data)
            cb(data)
        end, data.data.images, data.data.caption)
    elseif data.action == 'getFollowing' then
        CB.TriggerServerCallback('phone:instapic:getData', function(data)
            cb(data)
        end, 'following', data.data)
    elseif data.action == 'getFollowers' then
        CB.TriggerServerCallback('phone:instapic:getData', function(data)
            cb(data)
        end, 'followers', data.data)
    elseif data.action == 'getLikes' then
        CB.TriggerServerCallback('phone:instapic:getData', function(data)
            cb(data)
        end, 'likes', data.data)
    elseif data.action == 'setLive' then
        TriggerServerEvent('phone:instapic:setLive', data)
    elseif data.action == 'goLive' then
        Animations.openCamera()
        CAMERA_MODE = 1
        CAMERA_FLIPPED = true

        TriggerServerEvent('phone:instapic:startLive', data)

        cb(true)
    elseif data.action == 'addCall' then
        TriggerServerEvent('phone:instapic:addCall', data.id)
        cb(true)
    elseif data.action == 'sendLiveMessage' then
        TriggerServerEvent('phone:instapic:sendLiveMessage', data.data)
        cb(true)
    elseif data.action == 'stopViewing' then
        TriggerServerEvent('phone:instapic:stopViewing', data.username)
        cb(true)
    elseif data.action == 'sendMessage' then
        CB.TriggerServerCallback('phone:instapic:sendMessage', function(data)
            cb(data)
        end, data.username, data.message)
    elseif data.action == 'flipCamera' then
        -- flipCamera
        cb(true)
    end
end)

RegisterNetEvent('phone:instapic:addLiveMessage', function(data)
    SendReactMessage("instapic:addMessage", data)
end)

RegisterNetEvent('phone:instapic:setLive', function(data)
    SendReactMessage("instapic:setLive", data)
end)

RegisterNetEvent('phone:instapic:updateLives', function(data)
    SendReactMessage("instapic:updateLives", data)
end)

RegisterNetEvent('phone:instapic:endLive', function(data)
    SendReactMessage("instapic:liveEnded", data)
end)

RegisterNetEvent('phone:instapic:endCall', function(data)
    SendReactMessage("instapic:endCall", data)
end)

RegisterNetEvent('phone:instapic:updateViewers', function(data)
    SendReactMessage("instapic:updateViewers", data)
end)

RegisterNetEvent('phone:instapic:updateFollowers', function(data)
    SendReactMessage("instapic:setFollowers", data)
end)

RegisterNetEvent('phone:instapic:updateFollowing', function(data)
    SendReactMessage("instapic:setFollowing", data)
end)

RegisterNetEvent('phone:instapic:updateLikes', function(data)
    SendReactMessage("instapic:setLikes", data)
end)

RegisterNetEvent('phone:instapic:newMessage', function(data)
    SendReactMessage("instapic:newMessage", data)
end)
