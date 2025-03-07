
ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback("appstore:buyApp", function(source, cb, price)
local xPlayer = ESX.GetPlayerFromId(source)
if not xPlayer then
cb(false)
return
end

if xPlayer.getMoney() >= price then
xPlayer.removeMoney(price)
cb(true)
else
cb(false)
end
end)
