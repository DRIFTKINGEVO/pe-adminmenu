ESX = nil

PE_noclip = false
PE_godmode = false
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
				message = '🛡️ | Menu de admin'
			})
			AbrirMenuAdministrativo()
		elseif IsControlJustReleased(0, 56) and not isAdmin then 
			exports['t-notify']:Alert({
				style = 'error', 
				message = '🛡️ | No tienes permiso para ver esto.'
			})
        end 
        if PE_noclip then
            local ped = GetPlayerPed(-1)
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
		title    = 'Menu Administrativo',
		align    = 'top-left',
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
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local accion = data2.current.value
				if accion == 'del_veh' then
					TriggerEvent('PE-admin:delallveh')
					exports['t-notify']:Alert({
						style  =  'success',
						message  =  '✔️ | Has borrado todos los coches.'
					})
				elseif accion == 'del_veh_time' then
					TriggerServerEvent('PE-admin:delallcars')
				elseif accion == 'del_obj' then
					TriggerEvent('PE-admin:delallobj')
					exports['t-notify']:Alert({
						style  =  'success',
						message  =  '✔️ | Has borrado todos los objetos.'
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
				{label = _U('godmode'), value = 'godmode'},
				{label = _U('tp'), value = 'tp'},
				{label = _U('tpclose'), value = 'tpclose'},
				{label = _U('spawnCar'), value = 'spawnCar'},
				{label = _U('dv'), value = 'dv'},
				{label = _U('heal'), value = 'heal'},
                {label = _U('fix'), value = 'fix'},
                {label = _U('inv'), value = 'inv'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'admin_admin', {
				title    = _U('admin_admin'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local accion = data2.current.value
				if accion == 'noclip' then
                    TriggerEvent('PE-admin:nocliped')
				elseif accion == 'godmode' then
                    TriggerEvent('PE-admin:godmode')
				elseif accion == 'tp' then
					TPtoMarker()
-----------------------------------------------------------FUCK ME ------------------------------------
				elseif accion == 'tpclose' then
					local playerPed = GetPlayerPed(-1)
					local playerPedPos = GetEntityCoords(playerPed, true)
					local NearestVehicle = GetClosestVehicle(GetEntityCoords(playerPed, true), 1000.0, 0, 4)
					local NearestVehiclePos = GetEntityCoords(NearestVehicle, true)
					local NearestPlane = GetClosestVehicle(GetEntityCoords(playerPed, true), 1000.0, 0, 16384)
					local NearestPlanePos = GetEntityCoords(NearestPlane, true)
					exports['t-notify']:Alert({
						style  =  'info',
						message  =  'Espera, no te muevas...',
						duration = 1200
					})
					Citizen.Wait(1500)
					if (NearestVehicle == 0) and (NearestPlane == 0) then
						exports['t-notify']:Alert({
							style  =  'error',
							message  =  '❌ | Ninguno vehiculo encontrado.'
						})
					elseif (NearestVehicle == 0) and (NearestPlane ~= 0) then
						if IsVehicleSeatFree(NearestPlane, -1) then
							SetPedIntoVehicle(playerPed, NearestPlane, -1)
							SetVehicleAlarm(NearestPlane, false)
							SetVehicleDoorsLocked(NearestPlane, 1)
							SetVehicleNeedsToBeHotwired(NearestPlane, false)
						else
							local driverPed = GetPedInVehicleSeat(NearestPlane, -1)
							ClearPedTasksImmediately(driverPed)
							SetEntityAsMissionEntity(driverPed, 1, 1)
							DeleteEntity(driverPed)
							SetPedIntoVehicle(playerPed, NearestPlane, -1)
							SetVehicleAlarm(NearestPlane, false)
							SetVehicleDoorsLocked(NearestPlane, 1)
							SetVehicleNeedsToBeHotwired(NearestPlane, false)
						end
							exports['t-notify']:Alert({
								style  =  'success',
								message  =  '✔️ | Te has teletransportado correctamente.'
							})
					elseif (NearestVehicle ~= 0) and (NearestPlane == 0) then
						if IsVehicleSeatFree(NearestVehicle, -1) then
							SetPedIntoVehicle(playerPed, NearestVehicle, -1)
							SetVehicleAlarm(NearestVehicle, false)
							SetVehicleDoorsLocked(NearestVehicle, 1)
							SetVehicleNeedsToBeHotwired(NearestVehicle, false)
						else
							local driverPed = GetPedInVehicleSeat(NearestVehicle, -1)
							ClearPedTasksImmediately(driverPed)
							SetEntityAsMissionEntity(driverPed, 1, 1)
							DeleteEntity(driverPed)
							SetPedIntoVehicle(playerPed, NearestVehicle, -1)
							SetVehicleAlarm(NearestVehicle, false)
							SetVehicleDoorsLocked(NearestVehicle, 1)
							SetVehicleNeedsToBeHotwired(NearestVehicle, false)
						end
							exports['t-notify']:Alert({
								style  =  'success',
								message  =  '✔️ | Te has teletransportado correctamente.'
							})
					elseif (NearestVehicle ~= 0) and (NearestPlane ~= 0) then
						if Vdist(NearestVehiclePos.x, NearestVehiclePos.y, NearestVehiclePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) < Vdist(NearestPlanePos.x, NearestPlanePos.y, NearestPlanePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) then
							if IsVehicleSeatFree(NearestVehicle, -1) then
								SetPedIntoVehicle(playerPed, NearestVehicle, -1)
								SetVehicleAlarm(NearestVehicle, false)
								SetVehicleDoorsLocked(NearestVehicle, 1)
								SetVehicleNeedsToBeHotwired(NearestVehicle, false)
							else
								local driverPed = GetPedInVehicleSeat(NearestVehicle, -1)
								ClearPedTasksImmediately(driverPed)
								SetEntityAsMissionEntity(driverPed, 1, 1)
							DeleteEntity(driverPed)
								SetPedIntoVehicle(playerPed, NearestVehicle, -1)
								SetVehicleAlarm(NearestVehicle, false)
								SetVehicleDoorsLocked(NearestVehicle, 1)
								SetVehicleNeedsToBeHotwired(NearestVehicle, false)
							end
						elseif Vdist(NearestVehiclePos.x, NearestVehiclePos.y, NearestVehiclePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) > Vdist(NearestPlanePos.x, NearestPlanePos.y, NearestPlanePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) then
							if IsVehicleSeatFree(NearestPlane, -1) then
								SetPedIntoVehicle(playerPed, NearestPlane, -1)
								SetVehicleAlarm(NearestPlane, false)
								SetVehicleDoorsLocked(NearestPlane, 1)
								SetVehicleNeedsToBeHotwired(NearestPlane, false)
							else
								local driverPed = GetPedInVehicleSeat(NearestPlane, -1)
								ClearPedTasksImmediately(driverPed)
								SetEntityAsMissionEntity(driverPed, 1, 1)
								DeleteEntity(driverPed)
								SetPedIntoVehicle(playerPed, NearestPlane, -1)
								SetVehicleAlarm(NearestPlane, false)
								SetVehicleDoorsLocked(NearestPlane, 1)
								SetVehicleNeedsToBeHotwired(NearestPlane, false)
							end
						end
							exports['t-notify']:Alert({
								style  =  'success',
								message  =  '✔️ | Te has teletransportado correctamente.'
							})
					end
-----------------------------------------------------------FUCK ME ------------------------------------
				elseif accion == 'spawnCar' then
                    openGetterMenu('spawnCar')
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
		align    = 'top-left',
		elements = {
			{label = _U('player_list'), value = 'player_list'}
	}}, function(data, menu)
		if data.current.value == 'player_list' then
			ESX.TriggerServerCallback('PE-admin:jugadoresonline', function(players)
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
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
		
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_', {
						title    = _U('are_you_sure', data2.current.name),
						align    = 'top-left',
						elements = {
							{label = "test", value = 'freeze'},
							{label = _U('no'), value = 'no'}
						}
					}, function(data3, menu3)
						menu3.close()
						local name = data2.current.name
						local Playerid = data2.current.value
		
						if data3.current.value == 'freeze' then
							TriggerEvent('PEa-admin:freezePlayer')
							
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
				
				
function openGetterMenu(type)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'getterAdminMenu',
	{
		title = "Ingrese el parámetro correspondiente",
	}, function(data, menu)
		local parameter = data.value
		if type == "spawnCar" then
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

function openMoneyMenu(type)
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

-------Eventos

RegisterNetEvent('PE-admin:nocliped')
AddEventHandler('PE-admin:nocliped',function()
	PE_noclip = not PE_noclip
    local ped = GetPlayerPed(-1)

    if PE_noclip then
    	SetEntityInvincible(ped, true)
    	SetEntityVisible(ped, false, false)
    else
    	SetEntityInvincible(ped, false)
    	SetEntityVisible(ped, true, false)
    end

    if PE_noclip == true then 
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  '✔️ | Has activado el noclip.'
		})
    else
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  '❌ | Has desactivado el modo invisible.'
		})	
    end
end)

RegisterNetEvent('PE-admin:invisible')
AddEventHandler('PE-admin:invisible', function()
	PE_vanish = not PE_vanish
    local ped = GetPlayerPed(-1)
    SetEntityVisible(ped, not PE_vanish, false)
    if PE_vanish == true then 
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  '✔️ | Has activado el modo invisible.'
		})
    else
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  '❌ | Has desactivado el modo invisible.'
		})	
    end
end)

RegisterNetEvent('PE-admin:godmode')
AddEventHandler('PE-admin:godmode', function()
	godmode = not godmode
	local playerPed = PlayerPedId()
	SetEntityInvincible(playerPed, not godmode, false)
	if godmode then
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  '❌ | Has desactivado el Godmode.'
		})		
	else
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  '✔️ | Has activado el Godmode.'
		})		
	end
end)

RegisterNetEvent("PE-admin:clearchat")
AddEventHandler("PE-admin:clearchat", function()
    TriggerEvent('chat:clear', -1)
	exports['t-notify']:Alert({
		style  =  'info',
		message  =  '💬 | Has borrado todo el chat.'
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
			message  =  '✔️ | Has reparado el vehiculo.'
		})
    else
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  '❌ | Tienes que estar en un vehiculo.'
		})
    end
end)


RegisterNetEvent('PE-admin:healPlayer')
AddEventHandler('PE-admin:healPlayer', function()
    if isAdmin then 
        local PE_ped = PlayerPedId()
        SetEntityHealth(PE_ped, 200)
		exports['t-notify']:Alert({
			style  =  'success',
			message  =  '✔️ | Te has curado.'
		})
        ClearPedBloodDamage(PE_ped)
        ResetPedVisibleDamage(PE_ped)
        ClearPedLastWeaponDamage(PE_ped)
    else
		exports['t-notify']:Alert({
			style  =  'error',
			message  =  '❌ | No eres admin.'
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



RegisterNetEvent("PEa-admin:freezePlayer")
AddEventHandler("PEa-admin:freezePlayer", function(input)
	freeze = not freeze
	local player = PlayerId()
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
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  	return x,y,z
end

getCamDirection = function()
	local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
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

----Qalle Mod

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

                Citizen.Wait(10)
            end
			exports['t-notify']:Alert({
				style  =  'success',
				message  =  '✔️ | Te has teletransportado.'
			})
        else
			exports['t-notify']:Alert({
				style  =  'info',
				message  =  '❓ | Marca un punto.'
			})
        end
	else
		exports['t-notify']:Alert({
			style  =  'error',
			message = '🛡️ | No tienes permiso para realizar esta accion.'
		})
    end
end

---------Weapon Drop---------

function SetWeaponDrops()
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
		SetWeaponDrops()
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







---------------TEST FOR VIDEI
