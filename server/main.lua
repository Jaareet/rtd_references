---Copyright 2021 |-| ZeonFlux#4424 ----
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local polices = {}
local referencias = {}

function DeleteBlip(source, CurrentAsign)
    local Player = ESX.GetPlayerFromId(source)
    local name = Player.getName()
    for k,v in pairs(polices) do
        TriggerClientEvent('zeon_refuerzos:deleteRef', k, source, CurrentAsign, name)
    end
    referencias[source] = nil
end

function CreateBlip(source, color, CurrentAsign)
    local Player = ESX.GetPlayerFromId(source)
    local name = Player.getName()
    local playerPed = GetPlayerPed(source)
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    for k,v in pairs(polices) do
        TriggerClientEvent('zeon_refuerzos:setRef', k, source, pos, color, heading, CurrentAsign, name)
    end
    referencias[source] = true
end

RegisterServerEvent('zeon_refuerzos:setRef')
AddEventHandler('zeon_refuerzos:setRef', function(type, CurrentAsign)
    local source = source

    if(not polices[source]) then return end --no es policia. Quizás inyectó código
    
    if referencias[source] then --antes de crear otro blip, borro el existente
        TriggerEvent('zeon_notify:ShowNotification', "Has desactivado los ~o~ refuerzos", "Policia")
        DeleteBlip(source, CurrentAsign)
    end

    if type ~= 'nref' then --si he pulsado sobre otros -> activo también los nuevos
        CreateBlip(source, type, CurrentAsign)
    end

end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(referencias) do
            local policePed = GetPlayerPed(k)
            local policeCoords = GetEntityCoords(policePed)
            local policeHeading = GetEntityHeading(policePed)        
            for _,val in pairs(polices) do
                TriggerClientEvent('zeon_refuerzos:setRef', _, k, policeCoords, 3, policeHeading, "", "")
            end
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    if(xPlayer and xPlayer.job.name == "police") then
        polices[playerId] = true
    end
end)

AddEventHandler('esx:playerDropped', function(playerId)
    if polices[playerId] then
        polices[playerId] = nil
    end
end)

AddEventHandler('esx:setJob', function(source, job)
    if(polices[source] and job.name ~= "police") then
        polices[source] = nil
    end

    if(job.name == "police") then
        polices[source] = true
    end
end)

AddEventHandler('onServerResourceStart', function(name)
    if GetCurrentResourceName() == name then
        local xPlayers = ESX.GetPlayers()

        for k,v in pairs(xPlayers) do
            local xPlayer = ESX.GetPlayerFromId(v)

            if xPlayer.job.name == "police" then
                polices[v] = true
            end
        end
    end
end)
