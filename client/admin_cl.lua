ESX = nil

PE_noclip = false
PE_god = false
PE_vanish = false
PE_noclipSpeed = 2.01
PE = {}
Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

-- Variables 

local isAdmin

Citizen.CreateThread(function()
	PE.CheckAdmin()
    while true do 
        Wait(150)
    end
end)

PE.CheckAdmin = function()
    isAdmin = nil
    TriggerServerEvent('PE-admin:isAdministrator')
    while (isAdmin == nil) do
        Citizen.Wait(1)
    end
end

RegisterNetEvent('PE-admin:checkAdmin')
AddEventHandler('PE-admin:checkAdmin', function(state)
    isAdmin = state 
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
		if IsControlJustReleased(0, 56) and isAdmin then 
			exports['t-notify']:Alert({
				style = 'warning', 
				message = _U('admin_menu')
			})
			AbrirMenuAdministrativo()
		elseif IsControlJustReleased(0, 56) and not isAdmin then 
			exports['t-notify']:Alert({
				style = 'error', 
				message = _U('perms_false')
			})
        end 
        if PE_noclip then
            local ped = PlayerPedId()
            local x,y,z = getPosition()
            local dx,dy,dz = getCamDirection()
            local speed = PE_noclipSpeed
        
  
            SetEntityVelocity(ped, 0.05,  0.05,  0.05)
  
            if IsControlPressed(0, 32) then
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end
  
            if IsControlPressed(0, 269) then
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end
  
            SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
        end
	end
end)

function AbrirMenuAdministrativo()
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'admin_actions', {
		title    = _U('admin_menu_top'),
		align    = 'right',
		elements = {
			{label = _U('server_admin'), value = 'server_admin'},
            {label = _U('admin_admin'), value = 'admin_admin'},
            {label = _U('jugador_admin'), value = 'jugador_admin'}
	}}, function(data, menu)
		if data.current.value == 'server_admin' then
			local elements = {
				{label = _U('del_veh_time'), value = 'del_veh_time'},
				{label = _U('del_veh'), value = 'del_veh'},
				{label = _U('del_obj'), value = 'del_obj'},
				{label = _U('del_chat'), value = 'del_chat'},
				{label = _U('ten_min'), value = 'ten_min'},
				{label = _U('kick_all'), value = 'kick_all'},
				{label = _U('revive_all'), value = 'revive_all'},
                {label = _U('custom_announce'), value = 'custom_announce'}
            }
            
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'server_admin', {
				title    = _U('server_admin'),
				align    = 'right',
				elements = elements
			}, function(data2, menu2)
				local accion = data2.current.value
				if accion == 'del_veh' then
					TriggerEvent('PE-admin:delallveh')
					exports['t-notify']:Alert({
						style  =  'success',
						message  =  _U('delallveh_true')
					})
				elseif accion == 'del_veh_time' then
					TriggerServerEvent('PE-admin:delallcars')
				elseif accion == 'del_obj' then
					TriggerEvent('PE-admin:delallobj')
					exports['t-notify']:Alert({
						style  =  'success',
						message  =  '✔️ | Has borrado todos los objetos'
					})
				elseif accion == 'del_chat' then
					TriggerServerEvent('PE-admin:clearchat')
				elseif accion == 'ten_min' then
					TriggerServerEvent('PE-admin:anunciar')
				elseif accion == 'kick_all' then
					TriggerServerEvent('PE-admin:kickall')
				elseif accion == 'revive_all' then
					TriggerServerEvent('PE-admin:reviveall')
				elseif accion == 'custom_announce' then
					TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
				end
			end, function(data2, menu2)
				menu2.close()
            end)
		elseif data.current.value == 'admin_admin' then
			local elements = {
				{label = _U('noclip'), value = 'noclip'},
				{label = _U('god'), value = 'god'},
				{label = _U('tp'), value = 'tp'},
				{label = _U('tpveh'), value = 'tpveh'},
				{label = _U('spawnCar'), value = 'spawnCar'},
				{label = _U('dv'), value = 'dv'},
				{label = _U('heal'), value = 'heal'},
                {label = _U('fix'), value = 'fix'},
                {label = _U('inv'), value = 'inv'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'admin_admin', {
				title    = _U('admin_admin'),
				align    = 'right',
				elements = elements
			}, function(data2, menu2)
				local accion = data2.current.value
				if accion == 'noclip' then
                    TriggerEvent('PE-admin:noclip')
				elseif accion == 'god' then
                    TriggerEvent('PE-admin:god')
				elseif accion == 'tp' then
					TPtoMarker()
				elseif accion == 'tpveh' then
					GoVeh()
				elseif accion == 'spawnCar' then
                    openVehMenu('spawnCar')
				elseif accion == 'dv' then
                    TriggerEvent('esx:deleteVehicle')
				elseif accion == 'heal' then
                    TriggerEvent('PE-admin:healPlayer')
				elseif accion == 'fix' then
                    TriggerEvent( 'PE-admin:repairVehicle')
				elseif accion == 'inv' then
                    TriggerEvent('PE-admin:invisible')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'jugador_admin' then
			TriggerEvent("PE-admin:openplayermenu")
			-----------------------------------------------------------------------------------------------
		end
	end, function(data, menu)
		menu.close()
	end)
end

-----------------------------------------------------------------
RegisterNetEvent("PE-admin:openplayermenu")
AddEventHandler("PE-admin:openplayermenu", function()
	OpenPlayerMenu()
end)

function OpenPlayerMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_list', {
		title    = _U('player_list'),
		align    = 'right',
		elements = {
			{label = _U('player_list'), value = 'player_list'}
	}}, function(data, menu)
		if data.current.value == 'player_list' then
			ESX.TriggerServerCallback('PE-admin:playersonline', function(players)
				local elements = {}
				for i=1, #players, 1 do
						table.insert(elements, {
							label = players[i].name,
							value = players[i].source,
							name = players[i].name,
							identifier = players[i].identifier
						})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_', {
					title    = _U('player_list'),
					align    = 'right',
					elements = elements
				}, function(data2, menu2)
		
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_', {
						title    = _U('are_you_sure', data2.current.name),
						align    = 'right',
						elements = {
							{label = "Freeze", value = 'freeze'},
							{label = "Kick", value = 'kick'}
						}
					}, function(data3, menu3)
						menu3.close()
						local name = data3.current.name
						local Playerid = data3.current.value
						local identifier = data3.current.identifier
		
						if Playerid == 'freeze' then
							TriggerEvent('PE-admin:freezePlayer')
						elseif identifier == 'kick' then
							TriggerServerEvent('PE-admin:kickplayer')
							
						end
					end, function(data3, menu3)
						menu3.close()
					end)
		
				end, function(data2, menu2)
					menu2.close()
				end)
		
			end)
		elseif data.current.value == 'open_unwanted' then
			local elements = {}

			ESX.TriggerServerCallback("esx_wanted:retrieveWantedPlayers", function(playerArray)
		
				if #playerArray == 0 then
					ESX.ShowNotification(_U('no_wanted'))
					return
				end
		
				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = _U('wanted_player', playerArray[i].name, playerArray[i].wantedTime),name = playerArray[i].name, value = playerArray[i].identifier })
				end
		
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'wanted_unwanted_menu',
					{
						title = _U('open_unwanted'),
						align = "center",
						elements = elements
					},
				function(data2, menu2)
					local identifier = data2.current.value
					local playername = data2.current.name
		
					TriggerServerEvent("esx_wanted:unWantedPlayer",playername,identifier)
					if Config.GcphoneMessageUnWanted then
						TriggerServerEvent('gcPhone:sendMessage', 'police',_U('gcphone_message_unwanted', playername))
					end

					if PlayerData.job and PlayerData.job.name == 'police' then
						ESX.ShowNotification(_U('police_message_un',playername))
					end
		
					menu2.close()
		
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		elseif data.current.value == 'open_feature' then
			ESX.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'wanted_choose_time_menu',
				{
					title = _U('set_min')
				},
			function(data, menu)

				local wantedTime = tonumber(data.value)

				if wantedTime == nil then
					ESX.ShowNotification(_U('time_error'))
				else
					menu.close()

						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'wanted_choose_feature_menu',
							{
							title = _U('feature')
							},
						function(data2, menu2)
		
							local feature = data2.value
		
							if feature == nil then
								ESX.ShowNotification(_U('feature_error'))
							else
								menu2.close()
								local number = GetRandomNumber(4)
								TriggerServerEvent("esx_wanted:wantedFeature", number, wantedTime, feature)
							end
		
						end, function(data2, menu2)
							menu2.close()
						end)
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end
				
				
function openVehMenu(type)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'getterAdminMenu',
	{
		title = _U('veh_name'),
	}, function(data, menu)
		local parameter = data.value
		if type == "spawnCar" then
			TriggerEvent('esx:spawnVehicle', parameter)
			exports['t-notify']:Alert({
				style  =  'info',
				message  =  _U('spawn_true') ..parameter
			})
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

--[[function openMoneyMenu(type)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'getterMoneyMenu',
	{
		title = "Ingrese el parámetro correspondiente",
	}, function(data, menu)
		local parameter = data.value
		if type == "giveMoney" then
			TriggerEvent('esx:spawnVehicle', parameter)
			exports['t-notify']:Alert({
				style  =  'info',
				message  =  'Has tratado de spawnear un ' ..parameter
			})
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end
]]

-------Events--

RegisterNetEvent('PE-admin:noclip')
AddEventHandler('PE-admin:noclip',function()
	PE_noclip = not PE_noclip
    local ped = PlayerPedId()

    if PE_noclip == true then 
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  _U('noclip_true')
		})
    else
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  _U('noclip_false')
		})	
    end
end)

RegisterNetEvent('PE-admin:invisible')
AddEventHandler('PE-admin:invisible', function()
	PE_vanish = not PE_vanish
    local ped = PlayerPedId()
    SetEntityVisible(ped, not PE_vanish, false)
    if PE_vanish == true then 
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  _U('inv_true')
		})
    else
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  _U('inv_false')
		})	
    end
end)

RegisterNetEvent('PE-admin:god')
AddEventHandler('PE-admin:god', function()
	PE_god = not PE_god
	local playerPed = PlayerPedId()
	SetEntityInvincible(playerPed, not PE_god, true)
	if PE_god == true then
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  _U('god_false')
		})		
	else
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  _U('god_true')
		})		
	end
end)

RegisterNetEvent("PE-admin:clearchat")
AddEventHandler("PE-admin:clearchat", function()
    TriggerEvent('chat:clear', -1)
	exports['t-notify']:Alert({
		style  =  'info',
		message  =  _U('chat_false')
	})
end)

RegisterNetEvent('PE-admin:repairVehicle')
AddEventHandler('PE-admin:repairVehicle', function()
    local ply = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(ply)
    if IsPedInAnyVehicle(ply) then 
        SetVehicleFixed(plyVeh)
        SetVehicleDeformationFixed(plyVeh)
        SetVehicleUndriveable(plyVeh, false)
        SetVehicleEngineOn(plyVeh, true, true)
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  _U('fix_true')
		})
    else
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  _U('fix_false')
		})
    end
end)


RegisterNetEvent('PE-admin:healPlayer')
AddEventHandler('PE-admin:healPlayer', function()
    if isAdmin then 
        local PE_ped = PlayerPedId()
		SetEntityHealth(PE_ped, 200)
		SetPedArmour(PE_ped, 100)
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  _U('heal_true')
		})
        ClearPedBloodDamage(PE_ped)
        ResetPedVisibleDamage(PE_ped)
        ClearPedLastWeaponDamage(PE_ped)
    else
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  _U('user_perms')
		})
    end
end)

RegisterNetEvent("PE-admin:delallveh")
AddEventHandler("PE-admin:delallveh", function ()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
            SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
            SetEntityAsMissionEntity(vehicle, false, false) 
			DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then 
				DeleteVehicle(vehicle)
            end
        end
    end
end)

RegisterNetEvent("PE-admin:delallobj")
AddEventHandler("PE-admin:delallobj", function ()
	for object in EnumerateObjects() do
        SetEntityAsMissionEntity(object, false, false) 
		DeleteObject(object)
		if (DoesEntityExist(object)) then 
			DeleteObject(object)
		end
    end
end)

----ALL PLAYER OPTIONS

RegisterNetEvent("PE-admin:freezePlayer")
AddEventHandler("PE-admin:freezePlayer", function(input)
	freeze = not freeze
	local ped = PlayerPedId()
    if freeze == true then
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)
    else
        SetEntityCollision(ped, true)
	    FreezeEntityPosition(ped, false)  
        SetPlayerInvincible(player, false)
    end
end) 

----------Noclip function------------

getPosition = function()
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
  	return x,y,z
end

getCamDirection = function()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
	local pitch = GetGameplayCamRelativePitch()
  
	local x = -math.sin(heading*math.pi/180.0)
	local y = math.cos(heading*math.pi/180.0)
	local z = math.sin(pitch*math.pi/180.0)
  
	local len = math.sqrt(x*x+y*y+z*z)
	if len ~= 0 then
	  x = x/len
	  y = y/len
	  z = z/len
	end
  
	return x,y,z
end

----Qalle Mod Function

TPtoMarker = function()
    if isAdmin then
        local WaypointHandle = GetFirstBlipInfoId(8)

        if DoesBlipExist(WaypointHandle) then
            local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

            for height = 1, 1000 do
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                if foundGround then
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    break
                end

                Citizen.Wait(25)
            end
			exports['t-notify']:Alert({
				style  =  'success',
				message  =  _U('tp_true')
			})
        else
			exports['t-notify']:Alert({
				style  =  'info',
				message  =  _U('tp_false')
			})
        end
	else
		exports['t-notify']:Alert({
			style  =  'error',
			message = _U('user_perms')
		})
    end
end

---------Weapon Drop---------
function NoWeapons()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		NoWeapons()
	end
end)

------Players functions
function GetPlayers()
	local players = {}

	for _, i in ipairs(GetActivePlayers()) do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end

-------TP to veh
function GoVeh()
	local playerPed = PlayerPedId()
	local playerPedPos = GetEntityCoords(playerPed, true)
	local NearestVehicle = GetClosestVehicle(GetEntityCoords(playerPed, true), 1000.0, 0, 4)
	local NearestVehiclePos = GetEntityCoords(NearestVehicle, true)
	local NearestPlane = GetClosestVehicle(GetEntityCoords(playerPed, true), 1000.0, 0, 1000)
	local NearestPlanePos = GetEntityCoords(NearestPlane, true)
	exports['t-notify']:Alert({
		style  =  'info',
		message  =  _U('veh_wait'),
		duration = 1200
	})
	Citizen.Wait(1600)
	if (NearestVehicle == 0) and (NearestPlane == 0) then
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  _U('veh_false')
		})
	elseif (NearestVehicle == 0) and (NearestPlane ~= 0) then
		if IsVehicleSeatFree(NearestPlane, -1) then
			SetPedIntoVehicle(playerPed, NearestPlane, -1)
			SetVehicleAlarm(NearestPlane, false)
			SetVehicleDoorsLocked(NearestPlane, 1)
			SetVehicleNeedsToBeHotwired(NearestPlane, false)
			Citizen.Wait(1)
		else
			local driverPed = GetPedInVehicleSeat(NearestPlane, -1)
			ClearPedTasksImmediately(driverPed)
			SetEntityAsMissionEntity(driverPed, 1, 1)
			DeleteEntity(driverPed)
			SetPedIntoVehicle(playerPed, NearestPlane, -1)
			SetVehicleAlarm(NearestPlane, false)
			SetVehicleDoorsLocked(NearestPlane, 1)
			SetVehicleNeedsToBeHotwired(NearestPlane, false)
			Citizen.Wait(1)
		end
			exports['t-notify']:Alert({
				style  =  'success',
				message  =  _U('veh_true')
			})
	elseif (NearestVehicle ~= 0) and (NearestPlane == 0) then
		if IsVehicleSeatFree(NearestVehicle, -1) then
			SetPedIntoVehicle(playerPed, NearestVehicle, -1)
			SetVehicleAlarm(NearestVehicle, false)
			SetVehicleDoorsLocked(NearestVehicle, 1)
			SetVehicleNeedsToBeHotwired(NearestVehicle, false)
			Citizen.Wait(1)
		else
			local driverPed = GetPedInVehicleSeat(NearestVehicle, -1)
			ClearPedTasksImmediately(driverPed)
			SetEntityAsMissionEntity(driverPed, 1, 1)
			DeleteEntity(driverPed)
			SetPedIntoVehicle(playerPed, NearestVehicle, -1)
			SetVehicleAlarm(NearestVehicle, false)
			SetVehicleDoorsLocked(NearestVehicle, 1)
			SetVehicleNeedsToBeHotwired(NearestVehicle, false)
			Citizen.Wait(1)
		end
			exports['t-notify']:Alert({
				style  =  'success',
				message  =  _U('veh_true')
			})
	elseif (NearestVehicle ~= 0) and (NearestPlane ~= 0) then
		if Vdist(NearestVehiclePos.x, NearestVehiclePos.y, NearestVehiclePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) < Vdist(NearestPlanePos.x, NearestPlanePos.y, NearestPlanePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) then
			if IsVehicleSeatFree(NearestVehicle, -1) then
				SetPedIntoVehicle(playerPed, NearestVehicle, -1)
				SetVehicleAlarm(NearestVehicle, false)
				SetVehicleDoorsLocked(NearestVehicle, 1)
				SetVehicleNeedsToBeHotwired(NearestVehicle, false)
				Citizen.Wait(1)
			else
				local driverPed = GetPedInVehicleSeat(NearestVehicle, -1)
				ClearPedTasksImmediately(driverPed)
				SetEntityAsMissionEntity(driverPed, 1, 1)
				DeleteEntity(driverPed)
				SetPedIntoVehicle(playerPed, NearestVehicle, -1)
				SetVehicleAlarm(NearestVehicle, false)
				SetVehicleDoorsLocked(NearestVehicle, 1)
				SetVehicleNeedsToBeHotwired(NearestVehicle, false)
				Citizen.Wait(1)
			end
		elseif Vdist(NearestVehiclePos.x, NearestVehiclePos.y, NearestVehiclePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) > Vdist(NearestPlanePos.x, NearestPlanePos.y, NearestPlanePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) then
			if IsVehicleSeatFree(NearestPlane, -1) then
				SetPedIntoVehicle(playerPed, NearestPlane, -1)
				SetVehicleAlarm(NearestPlane, false)
				SetVehicleDoorsLocked(NearestPlane, 1)
				SetVehicleNeedsToBeHotwired(NearestPlane, false)
				Citizen.Wait(1)
			else
				local driverPed = GetPedInVehicleSeat(NearestPlane, -1)
				ClearPedTasksImmediately(driverPed)
				SetEntityAsMissionEntity(driverPed, 1, 1)
				DeleteEntity(driverPed)
				SetPedIntoVehicle(playerPed, NearestPlane, -1)
				SetVehicleAlarm(NearestPlane, false)
				SetVehicleDoorsLocked(NearestPlane, 1)
				SetVehicleNeedsToBeHotwired(NearestPlane, false)
				Citizen.Wait(1)
			end
		end
			exports['t-notify']:Alert({
				style  =  'success',
				message  =  _U('veh_true')
			})
		Citizen.Wait(1)	
	end
end