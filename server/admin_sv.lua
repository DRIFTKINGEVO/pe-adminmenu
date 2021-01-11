
PE = {}

local PEAdmins = { -- Your identifier
    'steam:110000118fe7433',
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

RegisterServerEvent('PE-admin:announce')
AddEventHandler('PE-admin:announce', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style  =  'info',
            duration  =  10000,
            title  =  'Anuncio Administrativo',
            message  =  '# **Va a haber una tormenta en 10 minutos**\n ## Tengan cuidado\n',
            sound  =  true
        })
    end
end)

--Not tested
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
            message = 'Se borraran todos los vehiculos vacios en 10 minutos.'
        })
        Citizen.Wait(420000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = 'Se borraran todos los vehiculos vacios en 3 minutos.'
        })
        Citizen.Wait(150000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = 'Se borraran todos los vehiculos vacios en 30 segundos.'
        })
        Citizen.Wait(30000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style  =  'success',
            duration = 5000,
            message  =  '✔️ Se han borrado todos los vehiculos con exito!'
        })
        TriggerClientEvent('PE-admin:delallveh', -1)
    end
end)

RegisterServerEvent("PE-admin:kickall")
AddEventHandler("PE-admin:kickall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		DropPlayer(xPlayers[i], 'Todos han sido kickeados debido al reinicio. Muchas gracias por tu paciencia.')
	end
end)

RegisterServerEvent("PE-admin:reviveall")
AddEventHandler("PE-admin:reviveall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx_ambulancejob:revive', xPlayers[i])
	end
end)

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

RegisterCommand("admin", function(source, args, rawCommand)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('t-notify:client:Custom', source, {
            style  =  'info',
            duration = 5000,
            message  =  _U('your_rank', xPlayer.getGroup())
        })
	end
end, false)

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
