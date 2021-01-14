
PE = {}

local PEAdmins = { -- Your identifier
    'steam:110000118fe7433',
    'steam:110000140848323',
}

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

PE.isAdmin = function()
    local PE_identifier = GetPlayerIdentifiers(src)
    PE_identifier = PE_identifier[1]
    for i, v in pairs(PEAdmins) do 
        if v == PE_identifier then 
            return true 
        end
    end 
    return false
end

--Basic needs
RegisterServerEvent('PE-admin:isAdministrator')
AddEventHandler('PE-admin:isAdministrator', function()
    local PEidentifier = GetPlayerIdentifiers(source)
    PEidentifier = PEidentifier[1]
    for a, v in pairs(PEAdmins) do 
        if v == PEidentifier then 
            TriggerClientEvent('PE-admin:checkAdmin', source, true)
            return true 
        end
    end 
    return false 
end)

ESX.RegisterServerCallback('PE-admin:playersonline', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
            name       = xPlayer.name,
			job        = xPlayer.job
		})
	end

	cb(players)
end)

--Actual work
RegisterServerEvent('PE-admin:announce')
AddEventHandler('PE-admin:announce', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style       =  'info',
            duration    =  10000,
            title       =  _U('admin_news'),
            message     =  _U('ten_min_close'),
            sound       =  true
        })
    end
end)


RegisterServerEvent('PE-admin:clearchat')
AddEventHandler('PE-admin:clearchat', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('PE-admin:clearchat', xPlayers[i], -1)
    end
end)

RegisterServerEvent('PE-admin:delallcars')
AddEventHandler('PE-admin:delallcars', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('10_min')
        })
        Citizen.Wait(420000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('3_min')
        })
        Citizen.Wait(150000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('30_sec')
        })
        Citizen.Wait(30000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style  =  'success',
            duration = 5000,
            message  =  _U('success_delall')
        })
        TriggerClientEvent('PE-admin:delallveh', -1)
    end
end)

RegisterServerEvent("PE-admin:kickall")
AddEventHandler("PE-admin:kickall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		DropPlayer(xPlayers[i], _U('kick_msg'))
	end
end)

RegisterServerEvent("PE-admin:freezePlayer")
AddEventHandler("PE-admin:freezePlayer", function(Playerid, name)
    local src = source
    local Playerid = tonumber(Playerid)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PE-admin:freezePlayer", Playerid, name)
end)

RegisterServerEvent("PE-admin:kickPlayer")
AddEventHandler("PE-admin:kickPlayer", function(Playerid, name)
    DropPlayer(Playerid, _U('kick_msg2') .. name .. _U('kick_id') .. Playerid)
    sendDisc(webhook, name .. _U('kick_hook'), _U('kick2_hook') .. Playerid, 56108)
end)

RegisterServerEvent("PE-admin:reviveall")
AddEventHandler("PE-admin:reviveall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx_ambulancejob:revive', xPlayers[i])
            sendDisc(webhook, _U('revive_hook'), _U('revive2_hook') .. "ID: " ..  xPlayers[i], 56108)
	end
end)

--Extra stuff
RegisterCommand("admin", function(source, args, rawCommand)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('t-notify:client:Custom', source, {
            style  =  'info',
            duration = 5000,
            message  =  _U('your_rank', xPlayer.getGroup())
        })
        sendDisc(webhook, _U('rank_hook') .. source, _U('rank2_hook', xPlayer.getGroup()), 56108)
	end
end, false)

function sendDisc (webhook, name, message, color)
    local webhook   = "https://discord.com/api/webhooks/798525432818434048/soEpjUXu260Jg37zOL_0DuDmCD-dLFQtWWL-3IkBNetdDylYhE_g45L01S61InHyIXto"
    local image     = "https://i.imgur.com/RI8z5GG.png"
    local embeds = {
        {
            ["title"]           = "pe-adminmenu",
            ["image"]           = avatar_url,
            ["color"]           = color,
            ["description"]     = message, name,
            ["footer"]          = {
            ["text"]            = "Project-Entity",
            ["icon_url"]        = "https://i.imgur.com/RI8z5GG.png",
           },
        }
    }
    
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds, avatar_url = image}), { ['Content-Type'] = 'application/json' })
end
