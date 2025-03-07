local L0_1, L1_1, L2_1 = nil, nil, nil
L0_1 = ESX.RegisterServerCallback
L1_1 = "yellowPages:getPosts"
function L2_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2 = nil, nil, nil, nil, nil
L3_2 = MySQL
L3_2 = L3_2.query
L3_2 = L3_2.await
L4_2 = [[
SELECT id, phone_number AS `number`, title, description, attachment, price, `timestamp`
FROM phone_yellow_pages_posts
ORDER BY `timestamp` DESC
LIMIT ?, ?
]]
L5_2 = {}
L6_2 = A2_2 or L6_2
if not A2_2 then
L6_2 = 0
end
L6_2 = L6_2 * 10
L7_2 = 10
L5_2[1] = L6_2
L5_2[2] = L7_2
return L3_2(L4_2, L5_2)
end
if L0_1 then L0_1(L1_1, L2_1) end
L0_1 = ESX.RegisterServerCallback
L1_1 = "yellowPages:search"
function L2_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = nil, nil, nil, nil, nil, nil
L3_2 = "%"
L4_2 = A2_2
L5_2 = "%"
L3_2 = L3_2 .. L4_2 .. L5_2
A2_2 = L3_2
L3_2 = MySQL
L3_2 = L3_2.query
L3_2 = L3_2.await

end
