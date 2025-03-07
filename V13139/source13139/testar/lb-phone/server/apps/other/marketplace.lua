local L0_1, L1_1, L2_1 = nil, nil, nil
L0_1 = ESX.RegisterServerCallback
L1_1 = "marketplace:getPosts"
function L2_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2 = nil, nil, nil, nil, nil
L3_2 = A2_2.page
if not L3_2 then
L3_2 = 0
end
L4_2 = MySQL
L4_2 = L4_2.query
L4_2 = L4_2.await
L5_2 = [[
SELECT id, phone_number AS `number`, title, description, attachments, price, `timestamp`
FROM phone_marketplace_posts
%s
ORDER BY `timestamp` DESC
LIMIT @page, @perPage
]]
L6_2 = L5_2
L5_2 = L5_2.format
L7_2 = A2_2.from
if L7_2 then
L7_2 = "WHERE phone_number = @number"
if L7_2 then
goto lbl_17
end
end
L7_2 = ""
::lbl_17::
L5_2 = L5_2(L6_2, L7_2)
L6_2 = {}
L7_2 = A2_2.from
L6_2["@number"] = L7_2
L7_2 = L3_2 * 10
L6_2["@page"] = L7_2
L6_2["@perPage"] = 10
return L4_2(L5_2, L6_2)
end
if L0_1 then L0_1(L1_1, L2_1) end
L0_1 = ESX.RegisterServerCallback
L1_1 = "marketplace:search"
function L2_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2 = nil, nil, nil, nil, nil
L3_2 = [[
SELECT id, phone_number AS `number`, title, description, attachments, price, `timestamp`
FROM phone_marketplace_posts
WHERE
title LIKE CONCAT(@query, "%")
OR description LIKE CONCAT("%", @query, "%")
]]
L4_2 = A2_2.from
if L4_2 then
L4_2 = L3_2
L5_2 = "AND phone_number = @number"
L4_2 = L4_2 .. L5_2
L3_2 = L4_2
else
L4_2 = L3_2
L5_2 = "OR phone_number LIKE CONCAT(\"%\", @query, \"%\")"
L4_2 = L4_2 .. L5_2
L3_2 = L4_2
end
L4_2 = L3_2
L5_2 = [[
ORDER BY `timestamp` DESC
LIMIT @page, @perPage
]]
L4_2 = L4_2 .. L5_2
L3_2 = L4_2
L4_2 = MySQL
L4_2 = L4_2.query
L4_2 = L4_2.await
L5_2 = L3_2
L6_2 = {}
L7_2 = A2_2.query
L6_2["@query"] = L7_2
L7_2 = A2_2.from
L6_2["@number"] = L7_2
L7_2 = A2_2.page
if not L7_2 then
L7_2 = 0
end
L7_2 = L7_2 * 10
L6_2["@page"] = L7_2
L6_2["@perPage"] = 10
return L4_2(L5_2, L6_2)
end
if L0_1 then L0_1(L1_1, L2_1) end
L0_1 = ESX.RegisterServerCallback
L1_1 = "marketplace:createPost"
function L2_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
L3_2 = A2_2.title
L4_2 = A2_2.description
L5_2 = A2_2.attachments
L6_2 = A2_2.price
if not (L3_2 and L4_2 and L5_2 and L6_2) or L6_2 < 0 then
L7_2 = false
return L7_2
end
L7_2 = ContainsBlacklistedWord
L8_2 = A0_2
L9_2 = "MarketPlace"
L10_2 = L3_2
L7_2 = L7_2(L8_2, L9_2, L10_2)
if not L7_2 then
L7_2 = ContainsBlacklistedWord
L8_2 = A0_2
L9_2 = "MarketPlace"
L10_2 = L4_2
L7_2 = L7_2(L8_2, L9_2, L10_2)
if not L7_2 then
goto lbl_33
end
end
L7_2 = false
do return L7_2 end
::lbl_33::
L7_2 = MySQL
L7_2 = L7_2.insert
L7_2 = L7_2.await
L8_2 = "INSERT INTO phone_marketplace_posts (phone_number, title, description, attachments, price) VALUES (?, ?, ?, ?, ?)"
L9_2 = {}
L10_2 = A1_2
L11_2 = L3_2
L12_2 = L4_2
L13_2 = json
L13_2 = L13_2.encode
L14_2 = L5_2
L13_2 = L13_2(L14_2)
L14_2 = L6_2
L9_2[1] = L10_2
L9_2[2] = L11_2
L9_2[3] = L12_2
L9_2[4] = L13_2
L9_2[5] = L14_2
L7_2 = L7_2(L8_2, L9_2)
if not L7_2 then
L8_2 = false
return L8_2
end
A2_2.number = A1_2
A2_2.id = L7_2
L8_2 = TriggerClientEvent
L9_2 = "phone:marketplace:newPost"
L10_2 = -1
L11_2 = A2_2
L8_2(L9_2, L10_2, L11_2)
L8_2 = TriggerEvent
L9_2 = "lb-phone:marketplace:newPost"
L10_2 = A2_2
L8_2(L9_2, L10_2)
L8_2 = Log
L9_2 = "Marketplace"
L10_2 = A0_2
L11_2 = "info"
L12_2 = L
L13_2 = "BACKEND.LOGS.MARKETPLACE_NEW_TITLE"
L12_2 = L12_2(L13_2)
L13_2 = L
L14_2 = "BACKEND.LOGS.MARKETPLACE_NEW_DESCRIPTION"
L15_2 = {}
L16_2 = FormatNumber
L17_2 = A1_2
L16_2 = L16_2(L17_2)
L15_2.seller = L16_2
L15_2.title = L3_2
L15_2.price = L6_2
L15_2.description = L4_2
L16_2 = json
L16_2 = L16_2.encode
L17_2 = L5_2
L16_2 = L16_2(L17_2)
L15_2.attachments = L16_2
L15_2.id = L7_2
L13_2, L14_2, L15_2, L16_2, L17_2 = L13_2(L14_2, L15_2)
L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
return L7_2
end
if L0_1 then L0_1(L1_1, L2_1) end
L0_1 = ESX.RegisterServerCallback
L1_1 = "marketplace:deletePost"
function L2_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
L3_2 = IsAdmin
L4_2 = A0_2
L3_2 = L3_2(L4_2)
L4_2 = MySQL
L4_2 = L4_2.update
L4_2 = L4_2.await
L5_2 = "DELETE FROM phone_marketplace_posts WHERE id = @id %s"
L6_2 = L5_2
L5_2 = L5_2.format
if L3_2 then
L7_2 = ""
if L7_2 then
goto lbl_15
end
end
L7_2 = "AND phone_number = @number"
::lbl_15::
L5_2 = L5_2(L6_2, L7_2)
L6_2 = {}
L6_2["@id"] = A2_2
L6_2["@number"] = A1_2
L4_2 = L4_2(L5_2, L6_2)
if L4_2 > 0 then
L5_2 = Log
L6_2 = "Marketplace"
L7_2 = A0_2
L8_2 = "error"
L9_2 = L
L10_2 = "BACKEND.LOGS.MARKETPLACE_DELETED"
L9_2 = L9_2(L10_2)
L10_2 = "**ID**: %s"
L11_2 = L10_2
L10_2 = L10_2.format
L12_2 = A2_2
L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2)
L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
L5_2 = true
return L5_2
end
L5_2 = false
return L5_2
end
if L0_1 then L0_1(L1_1, L2_1) end