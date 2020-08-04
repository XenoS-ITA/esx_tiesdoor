--        ___    ___ _______   ________   ________  ________       _______      ___    ___ _______        ___    ___         _______  ________  ________  ________     
--        |\  \  /  /|\  ___ \ |\   ___  \|\   __  \|\   ____\     |\  ___ \    |\  \  /  /|\  ___ \      |\  \  |\  \       /  ___  \|\   __  \|\   ____\|\  ___  \    
--        \ \  \/  / | \   __/|\ \  \\ \  \ \  \|\  \ \  \___|_    \ \   __/|   \ \  \/  / | \   __/|   __\_\  \_\_\  \_____/__/|_/  /\ \  \|\  \ \  \___|\ \____   \   
--         \ \    / / \ \  \_|/_\ \  \\ \  \ \  \\\  \ \_____  \    \ \  \_|/__  \ \    / / \ \  \_|/__|\____    ___    ____\__|//  / /\ \   __  \ \_____  \|____|\  \  
--          /     \/   \ \  \_|\ \ \  \\ \  \ \  \\\  \|____|\  \  __\ \  \_|\ \  /     \/   \ \  \_|\ \|___| \  \__|\  \___|   /  /_/__\ \  \|\  \|____|\  \  __\_\  \ 
--         /  /\   \    \ \_______\ \__\\ \__\ \_______\____\_\  \|\__\ \_______\/  /\   \    \ \_______\  __\_\  \_\_\  \_____|\________\ \_______\____\_\  \|\_______\
--        /__/ /\ __\    \|_______|\|__| \|__|\|_______|\_________\|__|\|_______/__/ /\ __\    \|_______| |\____    ____   ____\\|_______|\|_______|\_________\|_______|
--        |__|/ \|__|                                  \|_________|             |__|/ \|__|               \|___| \  \__|\  \___|                   \|_________|         
--                                                                                                              \ \__\ \ \__\                                           
--                                                                                                               \|__|  \|__|                                           
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

local hasAlreadyEnteredMarkerTies = false
local isInTiesMarker = false
local createdties = false
local createdties2 = false
local first = false
local second = false

-- Render 3d text
Citizen.CreateThread(function()
	while true do		
        Wait(0)	

		local coords = GetEntityCoords(GetPlayerPed(-1))		
        local distance = GetDistanceBetweenCoords(coords, 233.05, 215.78, 106.29, true)
        local distance2 = GetDistanceBetweenCoords(coords, 259.83, 204.62, 106.28, true)
            
        if distance < 1.0 then
            first = true
            if not createdties then
                DrawText3Ds(vector3(232.10, 215.36, 106.38), "Press [~g~E~w~] to fasten the ~b~ties", 0.35)
            else
                DrawText3Ds(vector3(232.10, 215.36, 106.38), "Press [~r~H~w~] to cut the ~b~ties", 0.35)
            end
        else
            first = false
        end

        if distance2 < 1.0 then
            second = true
            if not createdties2 then
                DrawText3Ds(vector3(259.42, 203.715, 106.38), "Press [~g~E~w~] to fasten the ~b~ties", 0.35)
            else
                DrawText3Ds(vector3(259.42, 203.715, 106.38), "Press [~r~H~w~] to cut the ~b~ties", 0.35)
            end
        else
            second = false
        end 
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do		
		Wait(0)		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		isInTiesMarker = false
		if (GetDistanceBetweenCoords(coords, 233.05, 215.78, 106.29, true) < 1.0) or (GetDistanceBetweenCoords(coords, 259.83, 204.62, 106.28, true) < 1.0) then
			isInTiesMarker = true
		end
		if isInTiesMarker and not hasAlreadyEnteredMarkerTies then
			hasAlreadyEnteredMarkerTies = true
		end
		if not isInTiesMarker and hasAlreadyEnteredMarkerTies then
			hasAlreadyEnteredMarkerTies = false
		end
	end
end)

-- Menu interactions
Citizen.CreateThread(function()
	while true do
		Wait(0)
	    if isInTiesMarker then
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback('esx_tiesdoor:ties', function(item)
                    if item then
                        if first and not createdties then
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, 232.87, 215.67, 105.29, 1, 0, 0, 1)
                            SetEntityHeading(ped, 116.78)
                            Animation()
                            createdties = true
                            --             X        Y         Z        Hash      Yaw    Type
                            ChangeDoor(231.5123, 216.5177, 106.4049, 110411286, 295.0, "lock")
                            ChangeDoor(232.6054, 214.1584, 106.4049, 110411286, 115.0, "lock")
                            CreateObj(232.10, 215.36, 106.25, 118.0)

                        elseif second and not createdties2 then
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, 259.80, 204.40, 105.29, 1, 0, 0, 1)
                            SetEntityHeading(ped, 157.21)
                            Animation()
                            createdties2 = true
                            --             X        Y         Z        Hash      Yaw    Type
                            ChangeDoor(258.2022, 204.1005, 106.4049, 110411286, -20.0, "lock")
                            ChangeDoor(260.6432, 203.2052, 106.4049, 110411286, 160.0, "lock")
                            CreateObj(259.44, 203.70, 106.25, 160.0)
                        
                        end
                    end
                end)
            elseif IsControlJustReleased(0, 74) then
                if first and createdties then
                    local ped = PlayerPedId()
                    SetEntityCoords(ped, 232.87, 215.67, 105.29, 1, 0, 0, 1)
                    SetEntityHeading(ped, 116.78)
                    Animation()
                    createdties = false
                    --             X        Y         Z        Hash     Yaw    Type
                    ChangeDoor(231.5123, 216.5177, 106.4049, 110411286,  0  , "unlock")
                    ChangeDoor(232.6054, 214.1584, 106.4049, 110411286,  0  , "unlock")
                    DeleteObj()
                elseif second and createdties2 then
                    local ped = PlayerPedId()
                    SetEntityCoords(ped, 259.80, 204.40, 105.29, 1, 0, 0, 1)
                    SetEntityHeading(ped, 157.21)
                    Animation()
                    createdties2 = false
                    --             X        Y         Z        Hash     Yaw    Type
                    ChangeDoor(258.2022, 204.1005, 106.4049, 110411286,  0  , "unlock")
                    ChangeDoor(260.6432, 203.2052, 106.4049, 110411286,  0  , "unlock")
                    DeleteObj()
                end
	    	end
	    end
	end
end)



---------------
-- Functions --
---------------

function Animation()
    local ped = PlayerPedId()
    -- Request Animation
    local animDict = "mp_arresting"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        RequestAnimDict(animDict)
        Citizen.Wait(10)
    end
    
    -- Start Animation
    TaskPlayAnim(ped, animDict, "a_uncuff", 8.0, 8.0, 2000, 1, 1, 0, 0, 0)
    Citizen.Wait(2000)
end

function ChangeDoor(x,y,z,hash,yaw,type)
    TriggerServerEvent("esx_tiesdoor:server:syncdoor", x,y,z,hash,yaw,type)
end

-- For Sync the client --
RegisterNetEvent("esx_tiesdoor:client:syncdoor")
AddEventHandler("esx_tiesdoor:client:syncdoor", function(x,y,z,hash,yaw,type)
    local obj = GetClosestObjectOfType(x,y,z, 1.0, hash)

    if type == "lock" then
        SetEntityRotation(obj, 0.0, 0.0, yaw, 2, true)
        FreezeEntityPosition(obj, true)
    elseif type == "unlock" then
        FreezeEntityPosition(obj, false)
    end
end)
------------------------

function CreateObj(x,y,z,r)
        local obj = CreateObject(GetHashKey("hei_prop_zip_tie_positioned"), vector3(x,y,z), true)
        SetEntityRotation(obj, 0, 0, r, true, false)
        FreezeEntityPosition(obj, true)
        SetEntityAsMissionEntity(obj)
end

function DeleteObj()
    local obj = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey("hei_prop_zip_tie_positioned"))

    if DoesEntityExist(obj) then
        DeleteEntity(obj)
    end
end

-- 3d Text Function
DrawText3Ds = function(coords, text, scale)
    local x,y,z = coords.x, coords.y, coords.z
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)

    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 280

    --DrawRect(_x, _y + 0.0115, -0.052 + factor, 0.033, 14, 14, 14, 100)
end