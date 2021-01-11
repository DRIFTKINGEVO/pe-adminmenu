ESX = nil
local jobGrade = ''
local job = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(15)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local discordid = 777055108013752320 --Change this
local time		= 250

Citizen.CreateThread(function()
	while true do
		if ESX.PlayerData.job then
			SetDiscordRichPresenceAssetSmall(ESX.PlayerData.job.name)
			job = ESX.PlayerData.job.label
			jobGrade = ESX.PlayerData.job.grade_label
			SetDiscordRichPresenceAssetSmallText(job .. " - " .. jobGrade)	
		else
			Citizen.Wait(time)
		end

		--MOD CODE BY sadboilogan
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
		local StreetHash = GetStreetNameAtCoord(x, y, z)
		Citizen.Wait(time)
		if StreetHash ~= nil then
			StreetName = GetStreetNameFromHashKey(StreetHash)
			if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
				if IsPedSprinting(PlayerPedId()) then
					SetDiscordRichPresenceAssetText("Trotando en "..StreetName)
				elseif IsPedRunning(PlayerPedId()) then
					SetDiscordRichPresenceAssetText("Corriendo en "..StreetName)
				elseif IsPedWalking(PlayerPedId()) then
					SetDiscordRichPresenceAssetText("Caminando en "..StreetName)
				elseif IsPedStill(PlayerPedId()) then
					SetDiscordRichPresenceAssetText("Parado en "..StreetName)
				end
			elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
				local VehSpeed = GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId()))
				local CurSpeed = UseKMH and math.ceil(VehSpeed * 3.6) or math.ceil(VehSpeed * 2.236936)
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				if CurSpeed > 50 then
					SetDiscordRichPresenceAssetText("Acelerando en "..StreetName.." en un "..VehName)
				elseif CurSpeed <= 50 and CurSpeed > 0 then
					SetDiscordRichPresenceAssetText("Manejando en "..StreetName.." en un "..VehName)
				elseif CurSpeed == 0 then
					SetDiscordRichPresenceAssetText("Estacionado en "..StreetName.." en un "..VehName)
				end
			elseif IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()) then
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 5.0 then
					SetDiscordRichPresenceAssetText("Volando sobre "..StreetName.." en un "..VehName)
				else
					SetDiscordRichPresenceAssetText("Estacionado en "..StreetName.." en un "..VehName)
				end
			elseif IsEntityInWater(PlayerPedId()) then
				SetDiscordRichPresenceAssetText("Nadando")
			elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))))
				SetDiscordRichPresenceAssetText("Navegando en un "..VehName)
			elseif IsPedInAnySub(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetDiscordRichPresenceAssetText("En un sumergible")
			end
		end

		SetRichPresence('ID:' .. GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))) .. ' | ' .. GetPlayerName(PlayerId()) .. ' | ' .. #GetActivePlayers() .. '/' .. tostring(32)) --Change the 32 to your players
		SetDiscordAppId(discordid)
		SetDiscordRichPresenceAsset('bombaylogo') --Change this

		Citizen.Wait(8*1000)
	end
end)
