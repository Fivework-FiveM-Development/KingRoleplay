local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1 = nil, nil, nil, nil, nil, nil
L0_1 = {}
L1_1 = RegisterNetEvent
L2_1 = "phone:battery:setBattery"
function L3_1(A0_2)
local L1_2, L2_2
L1_2 = Config
L1_2 = L1_2.Battery
L1_2 = L1_2.Enabled
if L1_2 then
L1_2 = type
L2_2 = A0_2
L1_2 = L1_2(L2_2)
if not ("number" ~= L1_2 or A0_2 < 0 or A0_2 > 100) then
goto lbl_19
end
end
L1_2 = debugprint
L2_2 = "setBattery: invalid battery"
do return L1_2(L2_2) end
::lbl_19::
L1_2 = GetEquippedPhoneNumber
L2_2 = source
L1_2 = L1_2(L2_2)
if not L1_2 then
return
end
L2_2 = L0_1
L2_2[L1_2] = A0_2
end
L1_1(L2_1, L3_1)
function L1_1(A0_2)
local L1_2
L1_2 = Config
L1_2 = L1_2.Battery
L1_2 = L1_2.Enabled
if not L1_2 then
L1_2 = false
return L1_2
end
L1_2 = L0_1
L1_2 = L1_2[A0_2]
L1_2 = 0 == L1_2
return L1_2
end
IsPhoneDead = L1_1
L1_1 = exports
L2_1 = "IsPhoneDead"
L3_1 = IsPhoneDead
L1_1(L2_1, L3_1)
function L1_1(A0_2)
local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
L1_2 = GetEquippedPhoneNumber
L2_2 = A0_2
L1_2 = L1_2(L2_2)
if L1_2 then
L2_2 = L0_1
L2_2 = L2_2[L1_2]
if L2_2 then
goto lbl_11
end
end
do return end
::lbl_11::
L2_2 = debugprint
L3_2 = "saving battery level (%s) for %s"
L4_2 = L3_2
L3_2 = L3_2.format
L5_2 = L0_1
L5_2 = L5_2[L1_2]
L6_2 = L1_2
L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
L2_2(L3_2, L4_2, L5_2, L6_2)
L2_2 = MySQL
L2_2 = L2_2.Async
L2_2 = L2_2.execute
L3_2 = "UPDATE phone_phones SET battery = @battery WHERE phone_number = @phoneNumber"
L4_2 = {}
L5_2 = L0_1
L5_2 = L5_2[L1_2]
L4_2["@battery"] = L5_2
L4_2["@phoneNumber"] = L1_2
function L5_2()
local L0_3, L1_3
L1_3 = L1_2
L0_3 = L0_1
L0_3[L1_3] = nil
end
L2_2(L3_2, L4_2, L5_2)
end
L2_1 = exports
L3_1 = "SaveBattery"
L4_1 = L1_1
L2_1(L3_1, L4_1)
function L2_1()
local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
L0_2 = debugprint
L1_2 = "saving all battery levels"
L0_2(L1_2)
L0_2 = GetPlayers
L0_2 = L0_2()
L1_2 = 1
L2_2 = #L0_2
L3_2 = 1
for L4_2 = L1_2, L2_2, L3_2 do
L5_2 = L1_1
L6_2 = L0_2[L4_2]
L5_2(L6_2)
end
end
L3_1 = exports
L4_1 = "SaveAllBatteries"
L5_1 = L2_1
L3_1(L4_1, L5_1)
L3_1 = AddEventHandler
L4_1 = "playerDropped"
function L5_1()
local L0_2, L1_2
L0_2 = L1_1
L1_2 = source
L0_2(L1_2)
end
L3_1(L4_1, L5_1)
L3_1 = AddEventHandler
L4_1 = "txAdmin:events:scheduledRestart"
function L5_1(A0_2)
local L1_2
L1_2 = A0_2.secondsRemaining
if 60 == L1_2 then
L1_2 = L2_1
L1_2()
end
end
L3_1(L4_1, L5_1)
L3_1 = AddEventHandler
L4_1 = "txAdmin:events:serverShuttingDown"
L5_1 = L2_1
L3_1(L4_1, L5_1)
L3_1 = AddEventHandler
L4_1 = "onResourceStop"
function L5_1(A0_2)
local L1_2
L1_2 = GetCurrentResourceName
L1_2 = L1_2()
if A0_2 == L1_2 then
L1_2 = L2_1
L1_2()
end
end
L3_1(L4_1, L5_1)
