
RegisterNUICallback('Birdy', function(data, cb)
    if data.action == 'isLoggedIn' then
        CB.TriggerServerCallback('phone:birdy:isLoggedIn', function(data)
            cb(data)
        end, data)
    elseif data.action == 'login' then
        CB.TriggerServerCallback('phone:birdy:login', function(data)
            cb(data)
        end, data.data.username, data.data.password)
    elseif data.action == 'createAccount' then
        CB.TriggerServerCallback('phone:birdy:createAccount', function(data)
            cb(data)
        end, data.data.name, data.data.username, data.data.password)
    elseif data.action == 'getNotifications' then
        CB.TriggerServerCallback('phone:birdy:getNotifications', function(data)
            cb(data)
        end, data.page)
    elseif data.action == 'getProfile' then
        CB.TriggerServerCallback('phone:birdy:getProfile', function(data)
            cb(data)
        end, data.data.username)
    elseif data.action == 'signOut' then
        CB.TriggerServerCallback('phone:birdy:signOut', function(data)
            cb(data)
        end)
    elseif data.action == 'updateProfile' then
        CB.TriggerServerCallback('phone:birdy:updateProfile', function(data)
            cb(data)
        end, data.data.name, data.data.bio, data.data.profile_picture, data.data.header)
    elseif data.action == 'sendTweet' then
        CB.TriggerServerCallback('phone:birdy:sendTweet', function(data)
            cb(data)
        end, data.data.username, data.data.content, data.data.attachments, data.data.replyTo, data.data.hashtags)
    elseif data.action == 'getRecentHashtags' then
        CB.TriggerServerCallback('phone:birdy:getRecentHashtags', function(data)
            cb(data)
        end)
    elseif data.action == 'getTweets' then
        CB.TriggerServerCallback('phone:birdy:getTweets', function(data)
            cb(data)
        end, data.filter, data.page)
    elseif data.action == 'toggleNotifications' then
        CB.TriggerServerCallback('phone:birdy:toggleNotifications', function(data)
            cb(data)
        end, data.data.username, data.data.toggle)
    elseif data.action == 'searchAccounts' then
        CB.TriggerServerCallback('phone:birdy:searchAccounts', function(data)
            cb(data)
        end, data.query)
    elseif data.action == 'searchTweets' then
        CB.TriggerServerCallback('phone:birdy:searchTweets', function(data)
            cb(data)
        end, data.query, data.page)
    elseif data.action == 'getMessages' then
        CB.TriggerServerCallback('phone:birdy:getMessages', function(data)
            cb(data)
        end, data.data.username, data.data.page)
    elseif data.action == 'sendMessage' then
        CB.TriggerServerCallback('phone:birdy:sendMessage', function(data)
            cb(data)
        end, data.data.recipient, data.data.content, data.data.attachments)
    elseif data.action == 'getRecentMessages' then
        CB.TriggerServerCallback('phone:birdy:getRecentMessages', function(data)
            cb(data)
        end, data.page)
    elseif data.action == 'searchAccounts' then
        CB.TriggerServerCallback('phone:birdy:searchAccounts', function(data)
            cb(data)
        end, data.query)
    elseif data.action == 'getFollowing' then
        CB.TriggerServerCallback('phone:birdy:getData', function(data)
            cb(data)
        end, 'following', data.data.username, data.data.page)
    elseif data.action == 'getFollowers' then
        CB.TriggerServerCallback('phone:birdy:getData', function(data)
            cb(data)
        end, 'followers', data.data.username, data.data.page)
    elseif data.action == 'getLikes' then
        CB.TriggerServerCallback('phone:birdy:getData', function(data)
            cb(data)
        end, 'likes', data.data.tweet_id, data.data.page)
    elseif data.action == 'getRetweeters' then
        CB.TriggerServerCallback('phone:birdy:getData', function(data)
            cb(data)
        end, 'retweeters', data.data.tweet_id, data.data.page)
    elseif data.action == 'getTweet' then
        CB.TriggerServerCallback('phone:birdy:getTweet', function(data)
            cb(data)
        end, data.tweetId)
    elseif data.action == 'toggleRetweet' then
        CB.TriggerServerCallback('phone:birdy:toggleInteraction', function(data)
            cb(data)
        end, 'retweet', data.tweet_id, data.retweeted)
    elseif data.action == 'toggleLike' then
        CB.TriggerServerCallback('phone:birdy:toggleInteraction', function(data)
            cb(data)
        end, 'like', data.tweet_id, data.liked)
    elseif data.action == 'toggleFollow' then
        CB.TriggerServerCallback('phone:birdy:toggleInteraction', function(data)
            cb(data)
        end, 'follow', data.data.username, data.data.following)
    elseif data.action == 'deleteTweet' then
        CB.TriggerServerCallback('phone:birdy:deleteTweet', function(data)
            cb(data)
        end, data.tweet_id)
    elseif data.action == 'ban' then
        TriggerServerEvent('ava:phone:ban', 'birdy', data.data.username, false)
    end
end)

RegisterNetEvent('phone:birdy:setLikes', function(data)
    SendReactMessage("birdy:setLikes", data)
end)

RegisterNetEvent('phone:birdy:setReplyCount', function(data)
    SendReactMessage("birdy:setReplies", data)
end)

RegisterNetEvent('phone:birdy:setRetweets', function(data)
    SendReactMessage("birdy:setRetweets", data)
end)

RegisterNetEvent('phone:birdy:updateFollowers', function(data)
    SendReactMessage("birdy:setFollowers", data)
end)

RegisterNetEvent('phone:birdy:updateFollowing', function(data)
    SendReactMessage("birdy:setFollowing", data)
end)

RegisterNetEvent('phone:birdy:newMessage', function(data)
    SendReactMessage("birdy:newMessage", data)
end)

RegisterNetEvent('phone:birdy:newtweet', function(data)
    SendReactMessage("birdy:newTweet", data)
end)
