ESX = exports['es_extended']:getSharedObject()

SE = function(e, ...) TriggerServerEvent(e, ...) end

TCE = function(e, ...) TriggerClientEvent(e, ...) end

RSE = function(e, h) RegisterServerEvent(e); ADH(e, h) end

ADH = function(e, h) AddEventHandler(e, h) end

RNE = function(e, h) RegisterNetEvent(e); ADH(e, h) end

W = function(t)
    return Citizen.Wait(t)
end

SN =  function(tx)
    return ESX.ShowNotification(tx)
end

SNS = function(tx)
    return  ESX.GetPlayerFromId(source).showNotification(tx)
end

CT = function(h) Citizen.CreateThread(h) end

EXC = function(c) ExecuteCommand(c) end