local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1 = nil, nil, nil, nil, nil, nil, nil, nil
L0_1 = Config
L0_1 = L0_1.Crypto

if not (L0_1 and L0_1.Enabled) then
    L0_1 = debugprint
    L1_1 = "crypto disabled"
    if L0_1 then L0_1(L1_1) end
    return
end
if L0_1 then
L0_1 = Config
L0_1 = L0_1.Crypto
L0_1 = L0_1.Enabled
if L0_1 then
end
end
L0_1 = debugprint
L1_1 = "crypto disabled"
if L0_1 then L0_1(L1_1)
do return end
L0_1 = 0
function L1_1(A0_2)
local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
L1_2 = L0_1
if L1_2 >= 5 then
L1_2 = false
return L1_2
end
L1_2 = L0_1
L1_2 = L1_2 + 1
L0_1 = L1_2
L1_2 = SetTimeout
L2_2 = 60000
function L3_2()
local L0_3, L1_3
L0_3 = L0_1
L0_3 = L0_3 - 1
L0_1 = L0_3
end
L1_2(L2_2, L3_2)
L1_2 = promise
L1_2 = L1_2.new
L1_2 = L1_2()
L2_2 = PerformHttpRequest
L3_2 = "https://api.coingecko.com/api/v3/"
L4_2 = A0_2
L3_2 = L3_2 .. L4_2
function L4_2(A0_3, A1_3)
local L2_3, L3_3, L4_3, L5_3
L2_3 = L1_2
L3_3 = L2_3
L2_3 = L2_3.resolve
if A1_3 then
L4_3 = json
L4_3 = L4_3.decode
L5_3 = A1_3
L4_3 = L4_3(L5_3)
if L4_3 then
goto lbl_12
end
end
L4_3 = false
::lbl_12::
L2_3(L3_3, L4_3)
end
L5_2 = "GET"
L6_2 = ""
L7_2 = {}
L7_2["Content-Type"] = "application/json"
L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
L2_2 = Citizen
L2_2 = L2_2.Await
L3_2 = L1_2
return L2_2(L3_2)
end
L2_1 = {}
L2_1.hasFetched = false
L3_1 = {}
L2_1.coins = L3_1
L3_1 = {}
L2_1.customCoins = L3_1
L3_1 = Config
L3_1 = L3_1.Crypto
L3_1 = L3_1.Coins
if L3_1 then
L3_1 = Config
L3_1 = L3_1.Crypto
L3_1 = L3_1.Coins
L3_1 = #L3_1
L3_1 = table
L3_1 = L3_1.concat
L4_1 = Config
L4_1 = L4_1.Crypto
L4_1 = L4_1.Coins
L5_1 = ","
L3_1 = L3_1 > 0 and L3_1
end
function L4_1()
if L4_1 then end
local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
L0_2 = GetResourceKvpInt
L1_2 = "lb-phone:crypto:lastFetched"
L0_2 = L0_2(L1_2)
if not L0_2 then
L0_2 = 0
end
L1_2 = os
L1_2 = L1_2.time
L1_2 = L1_2()
L2_2 = Config
L2_2 = L2_2.Crypto
L2_2 = L2_2.Refresh
L2_2 = L2_2 / 1000
L1_2 = L1_2 - L2_2
if L0_2 > L1_2 then
L1_2 = GetResourceKvpString
L2_2 = "lb-phone:crypto:coins"
L1_2 = L1_2(L2_2)
if L1_2 then
L2_2 = json
L2_2 = L2_2.decode
L3_2 = L1_2
L2_2 = L2_2(L3_2)
L2_1.coins = L2_2
L2_2 = pairs
L3_2 = L2_1.customCoins
L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
L8_2 = L2_1.coins
L8_2[L6_2] = L7_2
end
L2_2 = debugprint
L3_2 = "crypto: using kvp cache"
L2_2(L3_2)
return
end
end
L1_2 = L3_1
if L1_2 then
L1_2 = L1_1
L2_2 = "coins/markets?vs_currency="
L3_2 = Config
L3_2 = L3_2.Crypto
L3_2 = L3_2.Currency
L4_2 = "&sparkline=true&order=market_cap_desc&per_page=100&page=1&ids="
L5_2 = L3_1
L2_2 = L2_2 .. L3_2 .. L4_2 .. L5_2
L1_2 = L1_2(L2_2)
if L1_2 then
goto lbl_58
end
end
L1_2 = {}
::lbl_58::
if not L1_2 then
L2_2 = debugprint
L3_2 = "failed to fetch coins"
L2_2(L3_2)
return
end
L2_2 = 1
L3_2 = #L1_2
L4_2 = 1
for L5_2 = L2_2, L3_2, L4_2 do
L6_2 = L1_2[L5_2]
L7_2 = L2_1.coins
L8_2 = L6_2.id
L9_2 = {}
L10_2 = L6_2.id
L9_2.id = L10_2
L10_2 = L6_2.name
L9_2.name = L10_2
L10_2 = L6_2.symbol
L9_2.symbol = L10_2
L10_2 = L6_2.image
L9_2.image = L10_2
L10_2 = L6_2.current_price
L9_2.current_price = L10_2
L10_2 = L6_2.sparkline_in_7d
if L10_2 then
L10_2 = L10_2.price
end
L9_2.prices = L10_2
L10_2 = L6_2.price_change_percentage_24h
L9_2.change_24h = L10_2
L7_2[L8_2] = L9_2
end
L2_2 = pairs
L3_2 = L2_1.customCoins
L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
L8_2 = L2_1.coins
L8_2[L6_2] = L7_2
end
L2_2 = SetResourceKvpInt
L3_2 = "lb-phone:crypto:lastFetched"
L4_2 = os
L4_2 = L4_2.time
L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2()
L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
L2_2 = SetResourceKvp
L3_2 = "lb-phone:crypto:coins"
L4_2 = json
L4_2 = L4_2.encode
L5_2 = L2_1.coins
L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2)
L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
L2_2 = debugprint
L3_2 = "fetched coins"
L2_2(L3_2)
end
L5_1 = CreateThread
function L6_1()
local L0_2, L1_2, L2_2, L3_2
while true do
L0_2 = L4_1
L0_2()
L2_1.hasFetched = true
L0_2 = TriggerClientEvent
L1_2 = "phone:crypto:updateCoins"
L2_2 = -1
L3_2 = L2_1.coins
L0_2(L1_2, L2_2, L3_2)
L0_2 = Wait
L1_2 = Config
L1_2 = L1_2.Crypto
L1_2 = L1_2.Refresh
L0_2(L1_2)
end
end
L5_1(L6_1)
L5_1 = ESX.RegisterServerCallback
L6_1 = "crypto:get"
function L7_1(A0_2, A1_2)
local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
L2_2 = GetIdentifier
L3_2 = A0_2
L2_2 = L2_2(L3_2)
while true do
L3_2 = L2_1.hasFetched
if L3_2 then
break
end
L3_2 = Wait
L4_2 = 0
L3_2(L4_2)
end
L3_2 = MySQL
L3_2 = L3_2.Sync
L3_2 = L3_2.fetchAll
L4_2 = "SELECT coin, amount, invested FROM phone_crypto WHERE id=@identifier"
L5_2 = {}
L5_2["@identifier"] = L2_2
L3_2 = L3_2(L4_2, L5_2)
L4_2 = table
L4_2 = L4_2.deep_clone
L5_2 = L2_1.coins
L4_2 = L4_2(L5_2)
L5_2 = 1
L6_2 = #L3_2
L7_2 = 1
for L8_2 = L5_2, L6_2, L7_2 do
L9_2 = L3_2[L8_2]
if L9_2 then
L10_2 = L9_2.coin
L10_2 = L4_2[L10_2]
if L10_2 then
L10_2 = L9_2.coin
L10_2 = L4_2[L10_2]
L11_2 = L9_2.amount
L10_2.owned = L11_2
L10_2 = L9_2.coin
L10_2 = L4_2[L10_2]
L11_2 = L9_2.invested
L10_2.invested = L11_2
end
end
end
L5_2 = A1_2
L6_2 = L4_2
L5_2(L6_2)
end
L5_1(L6_1, L7_1)
L5_1 = ESX.RegisterServerCallback
L6_1 = "crypto:buy"
function L7_1(A0_2, A1_2, A2_2, A3_2)
local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
L4_2 = GetIdentifier
L5_2 = A0_2
L4_2 = L4_2(L5_2)
L5_2 = GetBalance
L6_2 = A0_2
L5_2 = L5_2(L6_2)
if A3_2 <= 0 then
L6_2 = A1_2
L7_2 = {}
L7_2.success = false
L7_2.msg = "INVALID_AMOUNT"
return L6_2(L7_2)
end
if A3_2 > L5_2 then
L6_2 = A1_2
L7_2 = {}
L7_2.success = false
L7_2.msg = "NO_MONEY"
return L6_2(L7_2)
end
L6_2 = L2_1.coins
L6_2 = L6_2[A2_2]
if not L6_2 then
L7_2 = A1_2
L8_2 = {}
L8_2.success = false
L8_2.msg = "INVALID_COIN"
return L7_2(L8_2)
end
L7_2 = L6_2.current_price
L7_2 = A3_2 / L7_2
L8_2 = MySQL
L8_2 = L8_2.Sync
L8_2 = L8_2.execute
L9_2 = "INSERT INTO phone_crypto (id, coin, amount, invested) VALUES (@identifier, @coin, @amount, @invested) ON DUPLICATE KEY UPDATE amount = amount + @amount, invested = invested + @invested"
L10_2 = {}
L10_2["@identifier"] = L4_2
L10_2["@coin"] = A2_2
L10_2["@amount"] = L7_2
L10_2["@invested"] = A3_2
L8_2(L9_2, L10_2)
L8_2 = RemoveMoney
L9_2 = A0_2
L10_2 = A3_2
L8_2(L9_2, L10_2)
L8_2 = Log
L9_2 = "Crypto"
L10_2 = A0_2
L11_2 = "success"
L12_2 = L
L13_2 = "BACKEND.LOGS.BOUGHT_CRYPTO"
L12_2 = L12_2(L13_2)
L13_2 = L
L14_2 = "BACKEND.LOGS.CRYPTO_DETAILS"
L15_2 = {}
L15_2.coin = A2_2
L15_2.amount = L7_2
L15_2.price = A3_2
L13_2, L14_2, L15_2 = L13_2(L14_2, L15_2)
L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
L8_2 = A1_2
L9_2 = {}
L9_2.success = true
L8_2(L9_2)
end
L5_1(L6_1, L7_1)
L5_1 = ESX.RegisterServerCallback
L6_1 = "crypto:sell"
function L7_1(A0_2, A1_2, A2_2, A3_2)
local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
L4_2 = GetIdentifier
L5_2 = A0_2
L4_2 = L4_2(L5_2)
if A3_2 <= 0 then
L5_2 = A1_2
L6_2 = {}
L6_2.success = false
L6_2.msg = "INVALID_AMOUNT"
return L5_2(L6_2)
end
L5_2 = MySQL
L5_2 = L5_2.Sync
L5_2 = L5_2.fetchAll
L6_2 = "SELECT amount, invested FROM phone_crypto WHERE id=@identifier AND coin=@coin"
L7_2 = {}
L7_2["@identifier"] = L4_2
L7_2["@coin"] = A2_2
L5_2 = L5_2(L6_2, L7_2)
L6_2 = #L5_2
if 0 == L6_2 then
L6_2 = A1_2
L7_2 = {}
L7_2.success = false
L7_2.msg = "NO_COINS"
return L6_2(L7_2)
end
L6_2 = L5_2[1]
if L6_2 then
L7_2 = L6_2.amount
if A3_2 > L7_2 then
L7_2 = A1_2
L8_2 = {}
L8_2.success = false
L8_2.msg = "NOT_ENOUGH_COINS"
return L7_2(L8_2)
end
end
L7_2 = L2_1.coins
L7_2 = L7_2[A2_2]
if not L7_2 then
L8_2 = A1_2
L9_2 = {}
L9_2.success = false
L9_2.msg = "INVALID_COIN"
return L8_2(L9_2)
end
L8_2 = L7_2.current_price
L8_2 = A3_2 * L8_2
L9_2 = MySQL
L9_2 = L9_2.Sync
L9_2 = L9_2.execute
L10_2 = "UPDATE phone_crypto SET amount = amount - @amount, invested = invested - @invested WHERE id=@identifier AND coin=@coin"
L11_2 = {}
L11_2["@identifier"] = L4_2
L11_2["@coin"] = A2_2
L11_2["@amount"] = A3_2
L11_2["@invested"] = L8_2
L9_2(L10_2, L11_2)
L9_2 = AddMoney
L10_2 = A0_2
L11_2 = L8_2
L9_2(L10_2, L11_2)
L9_2 = Log
L10_2 = "Crypto"
L11_2 = A0_2
L12_2 = "error"
L13_2 = L
L14_2 = "BACKEND.LOGS.SOLD_CRYPTO"
L13_2 = L13_2(L14_2)
L14_2 = L
L15_2 = "BACKEND.LOGS.CRYPTO_DETAILS"
L16_2 = {}
L16_2.coin = A2_2
L16_2.amount = A3_2
L16_2.price = L8_2
L14_2, L15_2, L16_2 = L14_2(L15_2, L16_2)
L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2)
L9_2 = A1_2
L10_2 = {}
L10_2.success = true
L9_2(L10_2)
end
L5_1(L6_1, L7_1)
L5_1 = ESX.RegisterServerCallback
L6_1 = "crypto:transfer"
function L7_1(A0_2, A1_2, A2_2, A3_2, A4_2)
local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
L5_2 = GetEquippedPhoneNumber
L6_2 = A0_2
L5_2 = L5_2(L6_2)
if not L5_2 then
L6_2 = A1_2
L7_2 = {}
L7_2.success = false
L7_2.msg = "NO_NUMBER"
return L6_2(L7_2)
end
L6_2 = GetSourceFromNumber
L7_2 = A4_2
L6_2, L7_2 = L6_2(L7_2)
if L6_2 then
L8_2 = GetIdentifier
L9_2 = L6_2
L8_2 = L8_2(L9_2)
L7_2 = L8_2
else
L8_2 = Config
L8_2 = L8_2.Item
L8_2 = L8_2.Unique
if L8_2 then
L8_2 = MySQL
L8_2 = L8_2.Sync
L8_2 = L8_2.fetchScalar
L9_2 = "SELECT id FROM phone_phones WHERE phone_number = @phoneNumber"
L10_2 = {}
L10_2["@phoneNumber"] = A4_2
L8_2 = L8_2(L9_2, L10_2)
L7_2 = L8_2
end
end
if not L7_2 then
L8_2 = A1_2
L9_2 = {}
L9_2.success = false
L9_2.msg = "INVALID_NUMBER"
return L8_2(L9_2)
end
L8_2 = L2_1.coins
L8_2 = L8_2[A2_2]
if not L8_2 then
L9_2 = A1_2
L10_2 = {}
L10_2.success = false
L10_2.msg = "INVALID_COIN"
return L9_2(L10_2)
end
L9_2 = GetIdentifier
L10_2 = A0_2
L9_2 = L9_2(L10_2)
if not (A3_2 <= 0) then
L10_2 = MySQL
L10_2 = L10_2.Sync
L10_2 = L10_2.fetchScalar
L11_2 = "SELECT amount FROM phone_crypto WHERE id=@identifier AND coin=@coin"
L12_2 = {}
L12_2["@identifier"] = L9_2
L12_2["@coin"] = A2_2
L10_2 = L10_2(L11_2, L12_2)
if not L10_2 then
L10_2 = 0
end
if not (A3_2 > L10_2) then
goto lbl_83
end
end
L10_2 = A1_2
L11_2 = {}
L11_2.success = false
L11_2.msg = "INVALID_AMOUNT"
do return L10_2(L11_2) end
::lbl_83::
L10_2 = MySQL
L10_2 = L10_2.Sync
L10_2 = L10_2.execute
L11_2 = "UPDATE phone_crypto SET amount = amount - @amount WHERE id=@identifier AND coin=@coin"
L12_2 = {}
L12_2["@identifier"] = L9_2
L12_2["@coin"] = A2_2
L12_2["@amount"] = A3_2
L10_2(L11_2, L12_2)
L10_2 = MySQL
L10_2 = L10_2.Sync
L10_2 = L10_2.execute
L11_2 = "INSERT INTO phone_crypto (id, coin, amount, invested) VALUES (@identifier, @coin, @amount, @invested) ON DUPLICATE KEY UPDATE amount = amount + @amount, invested = invested + @invested"
L12_2 = {}
L12_2["@identifier"] = L7_2
L12_2["@coin"] = A2_2
L12_2["@amount"] = A3_2
L12_2["@invested"] = 0
L10_2(L11_2, L12_2)
L10_2 = L2_1.coins
L11_2 = SendNotification
L12_2 = A4_2
L13_2 = {}
L13_2.app = "Crypto"
L14_2 = L
L15_2 = "BACKEND.CRYPTO.RECEIVED_TRANSFER_TITLE"
L16_2 = {}
L17_2 = L10_2[A2_2]
L17_2 = L17_2.name
L16_2.coin = L17_2
L14_2 = L14_2(L15_2, L16_2)
L13_2.title = L14_2
L14_2 = L
L15_2 = "BACKEND.CRYPTO.RECEIVED_TRANSFER_DESCRIPTION"
L16_2 = {}
L16_2.amount = A3_2
L17_2 = L10_2[A2_2]
L17_2 = L17_2.name
L16_2.coin = L17_2
L17_2 = math
L17_2 = L17_2.floor
L18_2 = L10_2[A2_2]
L18_2 = L18_2.current_price
L18_2 = A3_2 * L18_2
L18_2 = L18_2 + 0.5
L17_2 = L17_2(L18_2)
L16_2.value = L17_2
L14_2 = L14_2(L15_2, L16_2)
L13_2.content = L14_2
L11_2(L12_2, L13_2)
L11_2 = Log
L12_2 = "Crypto"
L13_2 = A0_2
L14_2 = "error"
L15_2 = L
L16_2 = "BACKEND.LOGS.TRANSFERRED_CRYPTO"
L15_2 = L15_2(L16_2)
L16_2 = L
L17_2 = "BACKEND.LOGS.TRANSFERRED_CRYPTO_DETAILS"
L18_2 = {}
L18_2.coin = A2_2
L18_2.amount = A3_2
L18_2.to = A4_2
L18_2.from = L5_2
L16_2, L17_2, L18_2 = L16_2(L17_2, L18_2)
L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
if L6_2 then
L11_2 = TriggerClientEvent
L12_2 = "phone:crypto:changeOwnedAmount"
L13_2 = L6_2
L14_2 = A2_2
L15_2 = A3_2
L11_2(L12_2, L13_2, L14_2, L15_2)
end
L11_2 = A1_2
L12_2 = {}
L12_2.success = true
L11_2(L12_2)
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "AddCrypto"
function L7_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 =nil, nil, nil, nil, nil, nil
L3_2 = GetIdentifier
L4_2 = A0_2
L3_2 = L3_2(L4_2)
L4_2 = L2_1.coins
L4_2 = L4_2[A1_2]
if not L4_2 then
L4_2 = print
L5_2 = "invalid coin"
L6_2 = A1_2
L4_2(L5_2, L6_2)
L4_2 = false
return L4_2
end
L4_2 = MySQL
L4_2 = L4_2.Async
L4_2 = L4_2.execute
L5_2 = "INSERT INTO phone_crypto (id, coin, amount, invested) VALUES (@identifier, @coin, @amount, @invested) ON DUPLICATE KEY UPDATE amount = amount + @amount, invested = invested + @invested"
L6_2 = {}
L6_2["@identifier"] = L3_2
L6_2["@coin"] = A1_2
L6_2["@amount"] = A2_2
L6_2["@invested"] = 0
L4_2(L5_2, L6_2)
L4_2 = TriggerClientEvent
L5_2 = "phone:crypto:changeOwnedAmount"
L6_2 = A0_2
L7_2 = A1_2
L8_2 = A2_2
L4_2(L5_2, L6_2, L7_2, L8_2)
L4_2 = true
return L4_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "RemoveCrypto"
function L7_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = nil, nil, nil, nil, nil, nil
L3_2 = GetIdentifier
L4_2 = A0_2
L3_2 = L3_2(L4_2)
L4_2 = L2_1.coins
L4_2 = L4_2[A1_2]
if not L4_2 then
L4_2 = print
L5_2 = "invalid coin"
L6_2 = A1_2
L4_2(L5_2, L6_2)
L4_2 = false
return L4_2
end
L4_2 = MySQL
L4_2 = L4_2.Async
L4_2 = L4_2.execute
L5_2 = "UPDATE phone_crypto SET amount = amount - @amount WHERE id=@identifier AND coin=@coin"
L6_2 = {}
L6_2["@identifier"] = L3_2
L6_2["@coin"] = A1_2
L6_2["@amount"] = A2_2
L4_2(L5_2, L6_2)
L4_2 = TriggerClientEvent
L5_2 = "phone:crypto:changeOwnedAmount"
L6_2 = A0_2
L7_2 = A1_2
L8_2 = -A2_2
L4_2(L5_2, L6_2, L7_2, L8_2)
L4_2 = true
return L4_2
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "AddCustomCoin"
function L7_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
local L7_2, L8_2, L9_2, L10_2, L11_2
L7_2 = assert
L8_2 = type
L9_2 = A0_2
L8_2 = L8_2(L9_2)
L8_2 = "string" == L8_2
L9_2 = "id must be a string"
L7_2(L8_2, L9_2)
L7_2 = assert
L8_2 = type
L9_2 = A1_2
L8_2 = L8_2(L9_2)
L8_2 = "string" == L8_2
L9_2 = "name must be a string"
L7_2(L8_2, L9_2)
L7_2 = assert
L8_2 = type
L9_2 = A2_2
L8_2 = L8_2(L9_2)
L8_2 = "string" == L8_2
L9_2 = "symbol must be a string"
L7_2(L8_2, L9_2)
L7_2 = assert
L8_2 = type
L9_2 = A3_2
L8_2 = L8_2(L9_2)
L8_2 = "string" == L8_2
L9_2 = "image must be a string"
L7_2(L8_2, L9_2)
L7_2 = assert
L8_2 = type
L9_2 = A4_2
L8_2 = L8_2(L9_2)
L8_2 = "number" == L8_2
L9_2 = "currentPrice must be a number"
L7_2(L8_2, L9_2)
L7_2 = assert
L8_2 = type
L9_2 = A5_2
L8_2 = L8_2(L9_2)
L8_2 = "table" == L8_2
L9_2 = "prices must be a table"
L7_2(L8_2, L9_2)
L7_2 = assert
L8_2 = type
L9_2 = A6_2
L8_2 = L8_2(L9_2)
L8_2 = "number" == L8_2
L9_2 = "change24h must be a number"
L7_2(L8_2, L9_2)
L7_2 = {}
L7_2.id = A0_2
L7_2.name = A1_2
L7_2.symbol = A2_2
L7_2.image = A3_2
L7_2.current_price = A4_2
L7_2.prices = A5_2
L7_2.change_24h = A6_2
L8_2 = L2_1.customCoins
L8_2[A0_2] = L7_2
L8_2 = L2_1.coins
L8_2[A0_2] = L7_2
L8_2 = SetResourceKvp
L9_2 = "lb-phone:crypto:coins"
L10_2 = json
L10_2 = L10_2.encode
L11_2 = L2_1.coins
L10_2, L11_2 = L10_2(L11_2)
L8_2(L9_2, L10_2, L11_2)
L8_2 = TriggerClientEvent
L9_2 = "phone:crypto:updateCoins"
L10_2 = -1
L11_2 = L2_1.coins
L8_2(L9_2, L10_2, L11_2)
end
L5_1(L6_1, L7_1)
L5_1 = exports
L6_1 = "GetCoin"
function L7_1(A0_2)
local L1_2
L1_2 = L2_1.coins
L1_2 = L1_2[A0_2]
return L1_2
end
L5_1(L6_1, L7_1) end