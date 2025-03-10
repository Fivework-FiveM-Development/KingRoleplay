if Config.Item.Inventory ~= "core_inventory" or not Config.Item.Unique or not Config.Item.Require then
return
end

if Config.Framework == 'qb' then
QB.Functions.CreateUseableItem(Config.Item.Name, function(source, item, data)
if item then
TriggerClientEvent("lb-phone:usePhoneItem", source, item)
end
end)
elseif Config.Framework == 'esx' then
ESX.RegisterUsableItem(Config.Item.Name, function(source, itemName, item)
if item then
TriggerClientEvent("lb-phone:usePhoneItem", source, item)
end
end)
end

local function GetItemsByName(source, name)
Citizen.Trace('Get Item by name', name)
local Player = ''
local inventoryName = ''
if Config.Framework == 'qb' then
Player = QB.Functions.GetPlayer(source)
inventoryName = 'content-' .. Player.PlayerData.citizenid
elseif Config.Framework == 'esx' then
Player = ESX.GetPlayerFromId(source)
inventoryName = 'content-' .. Player.identifier:gsub(":", "")
end

local inventory = exports['core_inventory']:getInventory(inventoryName)
local items = {}
for _, item in pairs(inventory) do
if item.name == name then
items[#items + 1] = item
end
end
-- Citizen.Trace('before for getitemsbyname')
-- Citizen.Trace(json.encode(items, { indent = true }) )
-- Citizen.Trace('return getitemsbyname' )
return items
end

---Function to check if a player has a phone with a specific number
---@param source any
---@param phoneNumber string
---@return boolean
function HasPhoneNumber(source, phoneNumber)
Citizen.Trace("checking if " .. source .. " has a phone item with number", phoneNumber)
local phones = GetItemsByName(source, Config.Item.Name)
Citizen.Trace('as item', #phones)
for i = 1, #phones do
local phone = phones[i]
if phoneNumber == nil and phone and phone.metadata and phone.metadata.lbPhoneNumber == nil then
Citizen.Trace("they do have empty phone")
return true
end
if phone and phone.metadata and phone.metadata.lbPhoneNumber == phoneNumber then
Citizen.Trace("they do")
return true
end
end
Citizen.Trace("they do not")
return false
end

---Function to set a phone number to a player's empty phone item
---@param source number
---@param phoneNumber string
---@return boolean success
function SetPhoneNumber(source, phoneNumber)
Citizen.Trace("setting phone number to", phoneNumber, "for", source)
local Player = ''
local inventoryName = ''
if Config.Framework == 'qb' then
Player = QB.Functions.GetPlayer(source)
inventoryName = 'content-' .. Player.PlayerData.citizenid
elseif Config.Framework == 'esx' then
Player = ESX.GetPlayerFromId(source)
inventoryName = 'content-' .. Player.identifier:gsub(":", "")
end
local inventory = exports['core_inventory']:getInventory(inventoryName)

for i = 1, #inventory do
local item = inventory[i]
if item and item.name == Config.Item.Name and item.info.lbPhoneNumber == nil then
item.metadata.lbPhoneNumber = phoneNumber
item.metadata.lbFormattedNumber = FormatNumber(phoneNumber)
exports['core_inventory']:updateMetadata(inventoryName, item.id, item.metadata)
return true
end
end
return false
end

function SetItemName(source, phoneNumber, name)
Citizen.Trace('Set Item Name', phoneNumber, name)
local Player = ''
local inventoryName = ''

if Config.Framework == 'qb' then
Player = QB.Functions.GetPlayer(source)
inventoryName = 'content-' .. Player.PlayerData.citizenid
elseif Config.Framework == 'esx' then
Player = ESX.GetPlayerFromId(source)
inventoryName = 'content-' .. Player.identifier:gsub(":", "")
end

local items = exports['core_inventory']:getInventory(inventoryName)
for i = 1, #items do
local item = items[i]
if item and item.name == Config.Item.Name and item.metadata.lbPhoneNumber == phoneNumber then
local metadata = item.metadata
metadata.lbPhoneName = name
metadata.lbFormattedNumber = FormatNumber(phoneNumber)
exports['core_inventory']:updateMetadata(inventoryName, item.id, metadata)
return true
end
end
end
