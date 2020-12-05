ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

RegisterCommand("spectate", function(source, args, user)
    TriggerClientEvent('esx_spectate:spectate', source, target)
end)

ESX.RegisterServerCallback('esx_spectate:getPlayerData', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)
    if xPlayer ~= nil then
        cb(xPlayer)
    end
end)

RegisterServerEvent('esx_spectate:kick')
AddEventHandler('esx_spectate:kick', function(target, msg)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getGroup() ~= 'user' then
		DropPlayer(target, msg)
	else
		print(('esx_spectate: %s attempted to kick a player!'):format(xPlayer.identifier))
		DropPlayer(source, "esx_spectate: you're not authorized to kick people dummy.")
	end
end)

ESX.RegisterServerCallback('esx_spectate:getOtherPlayerData', function(source, cb, target)
        
        local xPlayer = ESX.GetPlayerFromId(target)
        if xPlayer ~= nil then
            local identifier = GetPlayerIdentifiers(target)[1]
            
            local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
                ['@identifier'] = identifier
            })
            
            local user = result[1]
            local firstname = user['firstname']
            local lastname = user['lastname']
            local sex = user['sex']
            local dob = user['dateofbirth']
            local height = user['height'] .. " Centimetri"
            local money = user['money']
            local bank = user['bank']
            
            local data = {
                name = GetPlayerName(target),
                job = xPlayer.job,
                inventory = xPlayer.inventory,
                accounts = xPlayer.accounts,
                weapons = xPlayer.loadout,
                firstname = firstname,
                lastname = lastname,
                sex = sex,
                dob = dob,
                height = height,
                money = money,
                bank = bank
            }
            
            TriggerEvent('esx_license:getLicenses', target, function(licenses)
                data.licenses = licenses
                cb(data)
            end)
        end
end)

RegisterNetEvent('esx_spectate:checkS')
AddEventHandler('esx_spectate:checkS',function()
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx_spectate:checkC',source, thePlayer.name,xPlayers[i])
	end
end)

RegisterNetEvent('esx_spectate:checkSpos')
AddEventHandler('esx_spectate:checkSpos',function(id)
	local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        if xPlayers[i] == id then  
            local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
            local Thepos = GetEntityCoords(GetPlayerPed(thePlayer.source))
            TriggerClientEvent('esx_spectate:checkCpos',source, Thepos)
        end
	end
end)