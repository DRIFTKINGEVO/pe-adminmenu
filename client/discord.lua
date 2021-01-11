ESX = nil
local jobGrade = ''
local job = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(5)
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
Citizen.CreateThread(function()
	while true do
		if ESX.PlayerData.job then
			SetDiscordRichPresenceAssetSmall(ESX.PlayerData.job.name)
			job = ESX.PlayerData.job.label
			jobGrade = ESX.PlayerData.job.grade_label
			SetDiscordRichPresenceAssetSmallText(job .. " - " .. jobGrade)	
		else
			Citizen.Wait(650)
		end

		SetDiscordAppId(777055108013752320)

		SetDiscordRichPresenceAsset('bombaylogo')

		SetRichPresence('ID:' .. GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))) .. ' | ' .. GetPlayerName(PlayerId()) .. ' | ' ..' '.. "Jugadores" ..' ' .. #GetActivePlayers() .. '/' .. tostring(32))

        SetDiscordRichPresenceAssetText('Testing Server')

		Citizen.Wait(7.5*1000)
	end
end)
