---Copyright 2021 |-| RTDTonino#2060 ----
local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

local CurrentAsignation = "Sin Asignación" --key of below array. No tocar

local Asignaciones = {
    ["Sin Asignación"] = "Sin Asignación", --debe estar siempre
    ["Mando LSPD"] = "Mando LSPD",
    ["U-10"] = "U-10",
    ["Adam-10"] = "Adam-10"
}

function OpenAsignMenu()
    local elem = {}

    for k,v in pairs(Asignaciones) do
        table.insert(elem, {label = v, value = k})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'asignacion', {
		title    = "Asignaciones",
		align    = 'bottom-right',
		elements = elem
	}, function(data, menu)
		local v = data.current.value
		if v then
			CurrentAsignation = v
			Citizen.Wait(100)
			ESX.ShowNotification('Te has asignado en '..Asignaciones[v])
			ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()
	end)
end



function ReferenceMenu()
    local elementos = {}

    table.insert(elementos, {label = '🟢 Referencia 254', value = 11})
    table.insert(elementos, {label = '🟢 Referencia 10.6', value = 52})
    table.insert(elementos, {label = '🔵 Referencia 488', value = 3})
    table.insert(elementos, {label = '🟡 Referencia 487', value = 33})
    table.insert(elementos, {label = '🟣 [LSPD] 6 ADAM', value = 27})
    table.insert(elementos, {label = '🟡 [BCSD] 6 ADAM', value = 47})
    table.insert(elementos, {label = '🔴 Referencia QRR', value = 1})
    table.insert(elementos, {label = '⚪ Referencia', value = 0})
    table.insert(elementos, {label = 'Desactivar Referencias', value = 'nref'})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_reference_menu', {
        title    = "Referencias",
        align    = 'right',
        elements = elementos
    }, function(data, menu)
        local v = data.current.value
        
        if v == 1 then
			TriggerServerEvent('rtd_refuerzos:setRef', v, CurrentAsignation)
			ESX.UI.Menu.CloseAll()
		else
            if CurrentAsignation ~= "nasignacion" then
                TriggerServerEvent('rtd_refuerzos:setRef', v, CurrentAsignation)
                ESX.UI.Menu.CloseAll()
            else
                ESX.ShowNotification('Tienes que asignarte antes de pedir refuerzos')
            end
        end

    end, function(data, menu)
        menu.close()
    end)
end

local blips = {}

RegisterNetEvent('rtd_refuerzos:deleteRef')
AddEventHandler('rtd_refuerzos:deleteRef', function(source, asign, name)
    if(blips[source] and DoesBlipExist(blips[source])) then
        RemoveBlip(blips[source])
        blips[source] = nil
        ESX.ShowNotification(Asignaciones[asign].. ' | '..name.." ha desactivado su localizador")
    end
end)

RegisterNetEvent('rtd_refuerzos:setRef')
AddEventHandler('rtd_refuerzos:setRef', function(source, pos, color, heading, asign, name)	
	local xPlayer = ESX.GetPlayerData()
	if xPlayer.job.name == 'police' then
		if blips[source] then --actualiza blip
			SetBlipCoords(blips[source], pos.x,pos.y,pos.z)
			ShowHeadingIndicatorOnBlip(blips[source], true)
			SetBlipRotation(blips[source], math.floor(heading))
		else --crea blip, es nuevo
			blips[source] = AddBlipForCoord(pos.x, pos.y, pos.z)
			ESX.ShowNotification(Asignaciones[asign].. ' | '..name.." ha activado su localizador")
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(Asignaciones[asign]..' | '..name)
			EndTextCommandSetBlipName(blips[source])
			SetBlipColour(blips[source], color)
		end
	end
end)


RegisterKeyMapping('refuerzosMenu', 'Abrir menú refuerzos', 'keyboard', 'F6')

RegisterCommand('refuerzosMenu', function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_reference_menu_2', {
        title    = "Acciones refuerzo",
        align    = 'bottom-right',
        elements = 
        {
            {label = "Refuerzos", value = "ref"},
            {label = "Asignaciones", value = "asig"},
            {label = "Codigos Radiales", value = "cmenu"}
        }
    }, function(data, menu)
        local v = data.current.value
        ESX.UI.Menu.CloseAll()
        if v == "ref" then
            ReferenceMenu()
        elseif v == "asig" then
            OpenAsignMenu()
        elseif v == "cmenu" then
            OpenCMenu()
        end

    end, function(data, menu)
        menu.close()
    end)
end)

----

---Copyright 2022 |-| RTDTonino#2060 ----

function OpenCMenu ()
    
local elementos = {}

    table.insert(elementos, {label = 'Esperando Asignacion', value = '10.08'})
    table.insert(elementos, {label = 'Iniciar 10.06', value = '10.06'})
    table.insert(elementos, {label = 'Iniciar 254-V', value = '254v'})
  
    ESX.UI.Menu.CloseAll()
  
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cmenu', {
            title    = 'Codigos Radiales',
            align    = 'bottom-right',
            elements = elementos
        }, function(data, menu)
  
            local name = ESX.TriggerServerCallback("test", function(data) return data end)
            local name = ESX.TriggerServerCallback("job", function(jobs) return jobs end)
            local v = data.current.value

            if v == '10.08' then
                ExecuteCommand('rpol [LSPD] - 10.8')
            elseif v == 'cod2' then
                ExecuteCommand('rpol [LSPD] - ['..CurrentAsignation..'] | Inicia su Cod.2')
            elseif v =='10.06' then
                local ply = PlayerPedId()
                local plyl = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(ply, true))))
                    
                local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                local coordA = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)
                local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, 105.0, 0.0)
                local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, veh, 7)
                local a, b, c, d, e = GetShapeTestResult(frontcar)
    
                local fmodel = GetDisplayNameFromVehicleModel(GetEntityModel(e))
                local fplate = GetVehicleNumberPlateText(e)
                TriggerServerEvent('rtd_refuerzos:setRef', 52, CurrentAsignation)

                ExecuteCommand('rpol [LSPD] - [' ..CurrentAsignation.. "] | 10.6 | " ..fmodel.. " con matrícula "..fplate.." en "..plyl)
            elseif v == '254v' then
                    local ply = PlayerPedId()
                    local plyl = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(ply, true))))
                    
                    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local coordA = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)
                    local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, 105.0, 0.0)
                    local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, veh, 7)
                    local a, b, c, d, e = GetShapeTestResult(frontcar)
    
                    local fmodel = GetDisplayNameFromVehicleModel(GetEntityModel(e))
                    local fplate = GetVehicleNumberPlateText(e)
                    TriggerServerEvent('rtd_refuerzos:setRef', 11, CurrentAsignation)

                    ExecuteCommand('rpol [LSPD] - ['..CurrentAsignation.. "] inicia un 254-V a un "..fmodel.. " con matrícula "..fplate.. " por la zona de "..plyl..". Activamos referencias.")
            else
            end
        end, function(data, menu)
            menu.close()
        end
    )
end

RegisterKeyMapping('cmenu', 'Abrir menú central de radio', 'keyboard', 'F6')

---Copyright 2022 |-| RTDTonino#2060 ----
