local L0_1, L1_1, L2_1, L3_1 = nil, nil, nil, nil
L0_1 = ESX.RegisterServerCallback
L1_1 = "airShare:share"
function L2_1(A0_2, A1_2, A2_2, A3_2, A4_2)
local L5_2, L6_2, L7_2, L8_2, L9_2
L5_2 = Player
L6_2 = A0_2
L5_2 = L5_2(L6_2)
L5_2 = L5_2.state
L5_2 = L5_2.phoneName
if not L5_2 then
L6_2 = debugprint
L7_2 = "No sender name"
L6_2(L7_2)
L6_2 = false
return L6_2
end
L6_2 = {}
L6_2.name = L5_2
L6_2.source = A0_2
L6_2.device = "phone"
A4_2.sender = L6_2
if "tablet" == A3_2 then
L6_2 = GetResourceState
L7_2 = "lb-tablet"
L6_2 = L6_2(L7_2)
if "started" == L6_2 then
L6_2 = Player
L7_2 = A2_2
L6_2 = L6_2(L7_2)
L6_2 = L6_2.state
L6_2 = L6_2.lbTabletOpen
if L6_2 then
goto lbl_35
end
end
L6_2 = false
do return L6_2 end
::lbl_35::
L6_2 = TriggerClientEvent
L7_2 = "tablet:airShare:received"
L8_2 = A2_2
L9_2 = A4_2
L6_2(L7_2, L8_2, L9_2)
elseif "phone" == A3_2 then
L6_2 = Player
L7_2 = A2_2
L6_2 = L6_2(L7_2)
L6_2 = L6_2.state
L6_2 = L6_2.phoneOpen
if not L6_2 then
L6_2 = debugprint
L7_2 = "sendToSource's phone is not open"
L6_2(L7_2)
L6_2 = false
return L6_2
end
L6_2 = TriggerClientEvent
L7_2 = "phone:airShare:received"
L8_2 = A2_2
L9_2 = A4_2
L6_2(L7_2, L8_2, L9_2)
end
L6_2 = true
return L6_2
end
L3_1 = false
if L0_1 then L0_1(L1_1, L2_1, L3_1) end
L0_1 = RegisterNetEvent
L1_1 = "phone:airShare:interacted"
function L2_1(A0_2, A1_2, A2_2)
local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2 = nil, nil, nil, nil, nil, nil
L3_2 = source
L4_2 = type
L5_2 = A0_2
L4_2 = L4_2(L5_2)
if "number" == L4_2 then
L4_2 = type
L5_2 = A2_2
L4_2 = L4_2(L5_2)
if "boolean" == L4_2 then
if "tablet" == A1_2 then
L4_2 = TriggerClientEvent
L5_2 = "tablet:airShare:interacted"
L6_2 = A0_2
L7_2 = L3_2
L8_2 = A2_2
L4_2(L5_2, L6_2, L7_2, L8_2)
elseif "phone" == A1_2 then
L4_2 = TriggerClientEvent
L5_2 = "phone:airShare:interacted"
L6_2 = A0_2
L7_2 = L3_2
L8_2 = A2_2
L4_2(L5_2, L6_2, L7_2, L8_2)
end
end
end
end
if L0_1 then L0_1(L1_1, L2_1) end
L0_1 = {}
L0_1.image = true
L0_1.contact = true
L0_1.location = true
L0_1.note = true
L0_1.voicememo = true
L1_1 = exports
L2_1 = "AirShare"
function L3_1(A0_2, A1_2, A2_2, A3_2)
local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
L4_2 = assert
L5_2 = type
L6_2 = A0_2
L5_2 = L5_2(L6_2)
L5_2 = "number" == L5_2
L6_2 = "Invalid sender"
L4_2(L5_2, L6_2)
L4_2 = assert
L5_2 = type
L6_2 = A1_2
L5_2 = L5_2(L6_2)
L5_2 = "number" == L5_2
L6_2 = "Invalid target"
L4_2(L5_2, L6_2)
L4_2 = assert
L5_2 = L0_1
L5_2 = L5_2[A2_2]
L6_2 = "Invalid shareType"
L4_2(L5_2, L6_2)
L4_2 = assert
L5_2 = type
L6_2 = A3_2
L5_2 = L5_2(L6_2)
L5_2 = "table" == L5_2
L6_2 = "Invalid data"
L4_2(L5_2, L6_2)
L4_2 = GetEquippedPhoneNumber
L5_2 = A0_2
L4_2 = L4_2(L5_2)
if not L4_2 then
L5_2 = false
return L5_2
end
L5_2 = {}
L5_2.type = A2_2
L6_2 = {}
L7_2 = Player
L8_2 = A0_2
L7_2 = L7_2(L8_2)
if L7_2 then
L7_2 = L7_2.state
end
L7_2 = L7_2.phoneName
if not L7_2 then
L7_2 = L4_2
end
L6_2.name = L7_2
L6_2.source = A0_2
L6_2.device = "phone"
L5_2.sender = L6_2
if "image" == A2_2 then
L5_2.attachment = A3_2
L6_2 = assert
L7_2 = A3_2.src
L8_2 = "Invalid image data (missing src)"
L6_2(L7_2, L8_2)
L6_2 = L5_2.attachment
L6_2 = L6_2.timestamp
if not L6_2 then
L6_2 = L5_2.attachment
L7_2 = os
L7_2 = L7_2.time
L7_2 = L7_2()
L7_2 = L7_2 * 1000
L6_2.timestamp = L7_2
end
elseif "contact" == A2_2 then
L5_2.contact = A3_2
L6_2 = assert
L7_2 = type
L8_2 = L5_2.contact
L8_2 = L8_2.number
L7_2 = L7_2(L8_2)
L7_2 = "string" == L7_2
L8_2 = "Invalid/missing contact data (contact.number)"
L6_2(L7_2, L8_2)
L6_2 = assert
L7_2 = type
L8_2 = L5_2.contact
L8_2 = L8_2.firstname
L7_2 = L7_2(L8_2)
L7_2 = "string" == L7_2
L8_2 = "Invalid/missing contact data (contact.firstname)"
L6_2(L7_2, L8_2)
elseif "location" == A2_2 then
L6_2 = assert
L7_2 = A3_2.location
L8_2 = "Invalid location data (missing location)"
L6_2(L7_2, L8_2)
L6_2 = assert
L7_2 = type
L8_2 = A3_2.name
L7_2 = L7_2(L8_2)
L7_2 = "string" == L7_2
L8_2 = "Invalid/missing location data (location.name)"
L6_2(L7_2, L8_2)
L6_2 = A3_2.location
L5_2.location = L6_2
L6_2 = A3_2.name
L5_2.name = L6_2
elseif "note" == A2_2 then
L5_2.note = A3_2
L6_2 = assert
L7_2 = type
L8_2 = L5_2.note
L8_2 = L8_2.title
L7_2 = L7_2(L8_2)
L7_2 = "string" == L7_2
L8_2 = "Invalid/missing note data (note.title)"
L6_2(L7_2, L8_2)
L6_2 = assert
L7_2 = type
L8_2 = L5_2.note
L8_2 = L8_2.content
L7_2 = L7_2(L8_2)
L7_2 = "string" == L7_2
L8_2 = "Invalid/missing note data (note.content)"
L6_2(L7_2, L8_2)
elseif "voicememo" == A2_2 then
L5_2.voicememo = A3_2
L6_2 = assert
L7_2 = type
L8_2 = L5_2.voicememo
L8_2 = L8_2.title
L7_2 = L7_2(L8_2)
L7_2 = "string" == L7_2
L8_2 = "Invalid/missing voicememo data (voicememo.title)"
L6_2(L7_2, L8_2)
L6_2 = assert
L7_2 = type
L8_2 = L5_2.voicememo
L8_2 = L8_2.src
L7_2 = L7_2(L8_2)
L7_2 = "string" == L7_2
L8_2 = "Invalid/missing voicememo data (voicememo.src)"
L6_2(L7_2, L8_2)
L6_2 = assert
L7_2 = type
L8_2 = L5_2.voicememo
L8_2 = L8_2.duration
L7_2 = L7_2(L8_2)
L7_2 = "number" == L7_2
L8_2 = "Invalid/missing voicememo data (voicememo.duration)"
L6_2(L7_2, L8_2)
end
L6_2 = TriggerClientEvent
L7_2 = "phone:airShare:received"
L8_2 = A1_2
L9_2 = L5_2
L6_2(L7_2, L8_2, L9_2)
end
L1_1(L2_1, L3_1)
