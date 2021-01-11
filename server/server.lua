
ADM = {}

local ADMAdmins = {
    'steam:110000118fe7433',
}

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ADM.isAdmin = function()
    local ADM_identifier = GetPlayerIdentifiers(src)
    ADM_identifier = ADM_identifier[1]
    for i, v in pairs(ADMAdmins) do 
        if v == ADM_identifier then 
            return true 
        end
    end 
    return false
end

RegisterServerEvent('ADM-admin:anunciar')
AddEventHandler('ADM-admin:anunciar', function()
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
RegisterServerEvent('ADM-admin:clearchat')
AddEventHandler('ADM-admin:clearchat', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('ADM-admin:clearchat', xPlayers[i], -1)
    end
end)

RegisterServerEvent('ADM-admin:delallcars')
AddEventHandler('ADM-admin:delallcars', function()
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
        TriggerClientEvent('ADM-admin:delallveh', -1)
    end
end)

RegisterServerEvent("ADM-admin:kickall")
AddEventHandler("ADM-admin:kickall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		DropPlayer(xPlayers[i], 'Todos han sido kickeados debido al reinicio. Muchas gracias por tu paciencia.')
	end
end)

RegisterServerEvent("ADM-admin:reviveall")
AddEventHandler("ADM-admin:reviveall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx_ambulancejob:revive', xPlayers[i])
	end
end)

RegisterServerEvent('ADM-admin:isAdministrator')
AddEventHandler('ADM-admin:isAdministrator', function()
    local ADMidentifier = GetPlayerIdentifiers(source)
    ADMidentifier = ADMidentifier[1]
    for a, v in pairs(ADMAdmins) do 
        if v == ADMidentifier then 
            TriggerClientEvent('ADM-admin:checkAdmin', source, true)
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

ESX.RegisterServerCallback('ADM-admin:jugadoresonline', function(source, cb)
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