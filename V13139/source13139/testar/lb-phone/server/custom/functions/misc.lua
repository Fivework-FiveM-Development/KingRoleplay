---Function to check if an instagram user / source can go live
---@param source number
---@param username string
---@return boolean allowed Wheter or not the user can go live
---@return string | nil message The message to show to the user for why they can't go live
function CanGoLive(source, username)
-- implement your own logic here. by default, everyone can go live
return true
end

function CanCreateStory(source, username)
-- implement your own logic here. by default, everyone can go live
return true
end

if not Config.Item.Unique then
Wait(100)

if CreateUsableItem and Config.Item.Name then
CreateUsableItem(Config.Item.Name, function(src)
TriggerClientEvent("phone:toggleOpen", src, true)
end)
elseif CreateUsableItem and Config.Item.Names then
for i = 1, #Config.Item.Names do
CreateUsableItem(Config.Item.Names[i].name, function(src)
TriggerClientEvent("phone:usedPhoneVariation", src, i)
end)
end
end
end
