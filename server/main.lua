-- I don't recommend touching this file.
-- If you touch it, make sure it's because you need a modification made from HERE and not from the config.

local ESX, QBCore, DetectedFramework = nil, nil, nil

if not MySQL then
    print("^1[geg_ck]^7 Critical Error")
    print("^1[geg_ck]^7 oxmysql or mysql-async NOT found. These scripts are essential for geg_ck to work.")
    return
end

MySQL.ready(function()
	if Config.Framework == nil then Config.Framework = "auto" end

    if Config.Framework == "esx" then
        ESX = exports["es_extended"]:getSharedObject()
	elseif Config.Framework == "old-esx" then
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    elseif Config.Framework == "qbcore" then
        QBCore = exports["qb-core"]:GetCoreObject()
	elseif Config.Framework == "auto" then
		if GetResourceState('es_extended') == 'started' then
			local ok, err = pcall(function()
				ESX = exports["es_extended"]:getSharedObject()
			end)
			if not ok or ESX == nil then
				TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			end
		elseif GetResourceState('qb-core') == 'started' then
			QBCore = exports["qb-core"]:GetCoreObject()
		end
    else
		print("^1[geg_ck]^7 Invalid framework or framework NOT found.")
        return
	end

	if ESX then
    	DetectedFramework = "esx"
	elseif QBCore then
    	DetectedFramework = "qbcore"
	end

	print("^3[geg_ck] ^7Framework Detected! Type: " .. DetectedFramework)
	print(" ")
	print("^2[geg_ck] ^7Thanks for using my CK script!")


    local function CheckPermissions(source, identifier)
        local group
        if DetectedFramework == "esx" then
            group = ESX.GetPlayerFromId(source).getGroup()
        else
            group = QBCore.Functions.GetPlayer(source).Functions.GetPermission()
        end

        if Config.EnableCheckIdentifiers then
            for _, v in pairs(Config.CheckIdentifiers) do
                if v == identifier then
                    return true
                end
            end
        end

        if Config.EnablePermissions then
            for _, v in pairs(Config.AdminGroups) do
                if group == v then
                    return true
                end
            end
        end

        return false
    end

    RegisterCommand(Config.CKCommand, function(source, args)
        local src = source
        local xPlayer

        if DetectedFramework == "esx" then
            xPlayer = ESX.GetPlayerFromId(src)
            xPlayer.identifier = xPlayer.identifier
        else
            xPlayer = QBCore.Functions.GetPlayer(src)
            xPlayer.identifier = xPlayer.PlayerData.citizenid
        end

        if not xPlayer then return end

        if not CheckPermissions(src, xPlayer.identifier) then
            TriggerClientEvent('chat:addMessage', src, {
                color = Config.ChatMessageFormats.colors,
                args = {Config.ChatMessageFormats.prefix, Config.ChatMessageFormats.messageNoPermissions}
            })
            return
        end

        local targetId = tonumber(args[1])
        if not targetId then
            TriggerClientEvent('chat:addMessage', src, {
                color = Config.ChatMessageFormats.colors,
                args = {Config.ChatMessageFormats.prefix, Config.ChatMessageFormats.messageInvalidPlayerId}
            })
            return
        end

        local xTarget

        if DetectedFramework == "esx" then
            xTarget = ESX.GetPlayerFromId(targetId)
            if xTarget then xTarget.identifier = xTarget.identifier end
        else
            xTarget = QBCore.Functions.GetPlayer(targetId)
            if xTarget then xTarget.identifier = xTarget.PlayerData.citizenid end
        end

        if not xTarget then
            TriggerClientEvent('chat:addMessage', src, {
                color = Config.ChatMessageFormats.colors,
                args = {Config.ChatMessageFormats.prefix, Config.ChatMessageFormats.messageUnknownPlayer}
            })
            return
        end

        DropPlayer(targetId, Config.CkMessage)

        for k, v in pairs(Config.TablesToDelete) do
            MySQL.Async.execute('DELETE FROM ' .. k .. ' WHERE ' .. v .. ' = @identifier', {
                ['@identifier'] = xTarget.identifier
            })
        end

        TriggerClientEvent('chat:addMessage', src, {
            color = Config.ChatMessageFormats.colors,
            args = {Config.ChatMessageFormats.prefix, Config.ChatMessageFormats.messageSuccess}
        })
    end, false)
end)