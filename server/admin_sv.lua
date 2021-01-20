
PE = {}

local PEAdmins = {
    'steam:110000118fe7433',
    'steam:110000140848323',
    'steam:1100001163e23d5',
    'license:7c5d3098b26217c7affa6edabcc0015ae01d5a72',
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

RegisterServerEvent('PE-admin:isAdmin')
AddEventHandler('PE-admin:isAdmin', function()
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

RegisterServerEvent('PE-admin:announce')
AddEventHandler('PE-admin:announce', function()
    local xPlayers    = ESX.GetPlayers()
    sendDisc(webhook, _U('storm_hook'), Config.Storm, _U('storm2_hook'), 9371435)
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

RegisterCommand("admin", function(source, args, rawCommand)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('t-notify:client:Custom', source, {
            style  =  'info',
            duration = 5000,
            message  =  _U('your_rank', xPlayer.getGroup())
        })
        sendDisc(webhook, _U('rank_hook') .. source, Config.Admin, _U('rank2_hook', xPlayer.getGroup()), 16769280)
    elseif source ~=-1 then
        print(_U('console_id') .. source)
	end
end, false)

RegisterServerEvent('PE-admin:clearchat')
AddEventHandler('PE-admin:clearchat', function()
    local xPlayers    = ESX.GetPlayers()
    sendDisc(webhook, _U('chat_hook'), Config.Chat, _U('chat2_hook'), 9371435)
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('PE-admin:clearchat', xPlayers[i], -1)
    end
end)

RegisterServerEvent('PE-admin:delallvehtime')
AddEventHandler('PE-admin:delallvehtime', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        sendDisc(webhook, _U('delvehtime_hook'), Config.VehTime10, _U('delveh_10_hook'), 16390009)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('10_min')
        })
        Citizen.Wait(420000)
        sendDisc(webhook, _U('delvehtime_hook'), Config.VehTime3, _U('delveh_3_hook'), 16390009)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('3_min')
        })
        Citizen.Wait(150000)
        sendDisc(webhook, _U('delvehtime_hook'), Config.VehTime30, _U('delveh_30s_hook'), 16390009)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('30_sec')
        })
        Citizen.Wait(30000)
        sendDisc(webhook, _U('delvehtime_hook'), Config.VehTime, _U('delveh2_hook'), 16390009)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style  =  'success',
            duration = 5000,
            message  =  _U('success_delall')
        })
        TriggerClientEvent('PE-admin:delallveh', -1)
    end
end)

RegisterServerEvent('PE-admin:delallveh')
AddEventHandler('PE-admin:delallveh', function()
    local xPlayers    = ESX.GetPlayers()
    sendDisc(webhook, _U('delveh_hook'), Config.Veh, _U('delveh2_hook'), 9371435)
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('PE-admin:delallveh', -1)
    end
end)

RegisterServerEvent('PE-admin:delallobj')
AddEventHandler('PE-admin:delallobj', function()
    local xPlayers    = ESX.GetPlayers()
    sendDisc(webhook, _U('delobj_hook'), Config.Obj, _U('delobj2_hook'), 9371435)
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('PE-admin:delallobj', -1)
    end
end)

RegisterServerEvent("PE-admin:kickall")
AddEventHandler("PE-admin:kickall", function(source, name)
    local src = source
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        DropPlayer(xPlayers[i], _U('kick_msg'))
        sendDisc(webhook, _U('kickall_hook'), Config.KickAll, _U('kickall2_hook', xPlayers[i]), 9371435)
	end
end)

RegisterServerEvent("PE-admin:reviveall")
AddEventHandler("PE-admin:reviveall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx_ambulancejob:revive', xPlayers[i])
            sendDisc(webhook, _U('reviveall_hook'), Config.ReviveAll, _U('reviveall2_hook', xPlayers[i] ), 9371435)
	end
end)

RegisterServerEvent("PE-admin:freezePlayer")
AddEventHandler("PE-admin:freezePlayer", function(Playerid, name)
    local src = source
    local Playerid = tonumber(Playerid)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PE-admin:freezePlayer", Playerid, name)
    sendDisc(webhook,  _U('freeze_hook') .. src, Config.Freeze, _U('freeze2_hook') .. name .. "." .. _U('freeze3_hook') .. Playerid, 1872383)
end)

RegisterServerEvent("PE-admin:revivePlayer")
AddEventHandler("PE-admin:revivePlayer", function(Playerid, name)
    local src = source
    local Playerid = tonumber(Playerid)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PE-admin:revivePlayer", Playerid, name)
    sendDisc(webhook,  _U('revive_hook') .. src, Config.Revive, _U('revive2_hook') .. name .. "." .. _U('revive3_hook') .. Playerid, 1872383)
end)
RegisterServerEvent("PE-admin:killPlayer")
AddEventHandler("PE-admin:killPlayer", function(Playerid, name)
    local src = source
    local Playerid = tonumber(Playerid)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PE-admin:killPlayer", Playerid)
    sendDisc(webhook,  _U('kill_hook') .. src, Config.Kill, _U('kill2_hook') .. name .. "." .. _U('kill3_hook') .. Playerid, 1872383)
end)

RegisterServerEvent("PE-admin:weaponPlayer")
AddEventHandler("PE-admin:weaponPlayer", function(Playerid, name)
    local src = source
    local Playerid = tonumber(Playerid)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("PE-admin:weaponPlayer", Playerid, name)
    TriggerClientEvent('t-notify:client:Custom', Playerid, {
        style = 'info', 
        duration = 5000,
        message = _U('weapon_name', name)
    })
    sendDisc(webhook,  _U('weapon_hook') .. src, Config.WeaponPlayer, _U('weapon2_hook') .. name .. "." .. _U('weapon3_hook') .. Playerid, 1872383)
end)

RegisterServerEvent("PE-admin:kickPlayer")
AddEventHandler("PE-admin:kickPlayer", function(Playerid, name)
    DropPlayer(Playerid, _U('kick_msg2') .. name .. _U('kick_id') .. Playerid)
    sendDisc(webhook, name .. _U('kick_hook'), Config.Kick, _U('kick2_hook') .. Playerid, 1872383)
end)

-- Ty to esx_adminplus for the goto and bring
RegisterServerEvent("PE-admin:goto")
AddEventHandler("PE-admin:goto", function(Playerid, name)
	if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if PE.isAdmin then
            if Playerid and tonumber(Playerid) then
                local targetId = tonumber(Playerid)
                local xTarget = ESX.GetPlayerFromId(targetId)
                if xTarget then
                    local targetCoords = xTarget.getCoords()
                    local playerCoords = xPlayer.getCoords()
                    xPlayer.setCoords(targetCoords)
                    TriggerClientEvent('t-notify:client:Custom', xPlayer.source, {
                        style = 'info', 
                        duration = 5000,
                        message = _U('goto_admin', name)
                    })
                    TriggerClientEvent('t-notify:client:Custom', xTarget.source, {
                        style = 'info', 
                        duration = 5000,
                        message = _U('goto_player')
                    })
                    sendDisc(webhook, _U('goto_hook').. xPlayer.source, Config.Goto, _U('goto2_hook', xPlayer.source) .. name, 1872383)
                end
            end
        else
            TriggerClientEvent('t-notify:client:Custom', xPlayer.source, {
                style = 'info', 
                duration = 5000,
                message = _U('perms_false')
            })
        end
    end
end, false)

RegisterServerEvent("PE-admin:bring")
AddEventHandler("PE-admin:bring", function(Playerid, name)
	if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if PE.isAdmin then
            if Playerid and tonumber(Playerid) then
                local targetId = tonumber(Playerid)
                local xTarget = ESX.GetPlayerFromId(targetId)
                if xTarget then
                    local targetCoords = xTarget.getCoords()
                    local playerCoords = xPlayer.getCoords()
                    xTarget.setCoords(playerCoords)
                    TriggerClientEvent('t-notify:client:Custom', xPlayer.source, {
                        style = 'info', 
                        duration = 5000,
                        message = _U('bring_admin', name)
                    })
                    TriggerClientEvent('t-notify:client:Custom', xTarget.source, {
                        style = 'info', 
                        duration = 5000,
                        message = _U('bring_player')
                    })
                    sendDisc(webhook, _U('bring_hook') .. xPlayer.source, Config.Bring, _U('bring2_hook', xPlayer.source) .. name, 1872383)
                end
            end
        else
            TriggerClientEvent('t-notify:client:Custom', xPlayer.source, {
                style = 'info', 
                duration = 5000,
                message = _U('perms_false')
            })
        end
    end
end, false)

AddEventHandler('playerConnecting', function()
    local name = GetPlayerName(source)
    local hex = GetPlayerIdentifier(source)
    sendDisc(webhook, name .. _U('join_hook'), Config.Hex, _U('join2_hook') .. hex, 16769280)
end)

AddEventHandler('playerDropped', function()
    local name = GetPlayerName(source)
    local endp = GetPlayerEndpoint(source)
    sendDisc(webhook, name .. _U('leave_hook'), Config.EndP, _U('leave2_hook') .. endp, 16769280)
end)

function sendDisc (webhook, name, image, message, color)
    local webhook   = "https://discord.com/api/webhooks/798525432818434048/soEpjUXu260Jg37zOL_0DuDmCD-dLFQtWWL-3IkBNetdDylYhE_g45L01S61InHyIXto"
    local avatar     = Config.Avatar
    local embeds = {
        {
            ["title"]           = "pe-adminmenu",
            ["image"] ={
                ["url"]         =  image,
            },
            ["color"]           = color,
            ["description"]     = message, name,
            ["footer"]          = {
            ["text"]            = "Project-Entity",
            ["icon_url"]        = Config.Icon,
           },
        }
    }
    
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end


