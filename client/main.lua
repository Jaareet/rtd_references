---Copyright 2021 |-| ZeonFlux#4424 ----
local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

local CurrentAsignation = "Sin Asignación" --key of below array. No tocar


function OpenAsignMenu()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'asignacion', {
		title    = "Asignaciones",
		align    = 'bottom-right',
		elements = {

			{label = "Mando LSPD", value = 'mandolspd'},
			{label = "Mando BCSD",   value = 'mandobcsd'},
			{label = "U-10", value = 'u10'},
			{label = "U-20",   value = 'u20'},
			{label = "U-30",   value = 'u30'},
			{label = "U-40",   value = 'u40'},
			{label = "U-50",   value = 'u50'},
			{label = "ADAM-10",   value = 'adam10'},
			{label = "ADAM-20",   value = 'adam20'},
			{label = "ADAM-30",   value = 'adam30'},
			{label = "ADAM-40",   value = 'adam40'},
			{label = "ADAM-50",   value = 'adam50'},
			{label = "ADAM-60",   value = 'adam60'},
			{label = "ADAM-70",   value = 'adam70'},
			{label = "ADAM-80",   value = 'adam80'},
			{label = "ADAM-90",   value = 'adam90'},
			{label = "MARY-1",   value = 'mary1'},
			{label = "MARY-2",   value = 'mary2'},
			{label = "MARY-3",   value = 'mary3'},
			{label = "MARY-4",   value = 'mary4'},
			{label = "ALPHA-10",   value = 'alpha10'},
			{label = "ALPHA-20",   value = 'alpha20'},
			{label = "ALPHA-30",   value = 'alpha30'},
			{label = "ALPHA-40",   value = 'alpha40'},
			{label = "BRAVO-10",   value = 'bravo10'},
			{label = "BRAVO-20",   value = 'bravo20'},
			{label = "BRAVO-30",   value = 'bravo30'},
			{label = "BRAVO-40",   value = 'bravo40'},
			{label = "MIKE-1",   value = 'mike1'},
			{label = "MIKE-2",   value = 'mike2'},
			{label = "CHARLIE-10",   value = 'charlie10'},
			{label = "CHARLIE-20",   value = 'charlie20'},
			{label = "TAC-1",   value = 'tac1'},
			{label = "TAC-2",   value = 'tac2'},
			{label = "TAC-3",   value = 'tac3'},
			{label = "TAC-4",   value = 'tac4'},

    }}, function(data, menu)
		local v = data.current.value
		if v then
			CurrentAsignation = data.current.label
			Citizen.Wait(100)
            TriggerEvent('zeon_notify:ShowNotification', 'Te has asignado en '..data.current.label, "Policia")
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
			TriggerServerEvent('zeon_refuerzos:setRef', v, CurrentAsignation)
			ESX.UI.Menu.CloseAll()
		else
            if CurrentAsignation ~= "Sin Asignación" then
                TriggerServerEvent('zeon_refuerzos:setRef', v, CurrentAsignation)
                ESX.UI.Menu.CloseAll()
            else
                TriggerEvent('zeon_notify:ShowNotification', 'Tienes que asignarte antes de pedir refuerzos', "Policia")
            end
        end

    end, function(data, menu)
        menu.close()
    end)
end

local blips = {}

RegisterNetEvent('zeon_refuerzos:deleteRef')
AddEventHandler('zeon_refuerzos:deleteRef', function(source, asign, name)
    if(blips[source] and DoesBlipExist(blips[source])) then
        RemoveBlip(blips[source])
        blips[source] = nil
        TriggerEvent('zeon_notify:ShowNotification', asign.. ' | '..name.." ha desactivado su localizador", "Policia")
    end
end)

RegisterNetEvent('zeon_refuerzos:setRef')
AddEventHandler('zeon_refuerzos:setRef', function(source, pos, color, heading, asign, name)	
	local xPlayer = ESX.GetPlayerData()
	if xPlayer.job.name == 'police' then
		if blips[source] then --actualiza blip
			SetBlipCoords(blips[source], pos.x,pos.y,pos.z)
			ShowHeadingIndicatorOnBlip(blips[source], true)
			SetBlipRotation(blips[source], math.floor(heading))
		else --crea blip, es nuevo
			blips[source] = AddBlipForCoord(pos.x, pos.y, pos.z)
            TriggerEvent('zeon_notify:ShowNotification', asign.. ' | '..name.." ha activado su localizador", "Policia")
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(asign..' | '..name)
			EndTextCommandSetBlipName(blips[source])
			SetBlipColour(blips[source], color)
		end
	end
end)


RegisterKeyMapping('refuerzosMenu', 'Abrir menú refuerzos', 'keyboard', 'F7')

RegisterCommand('refuerzosMenu', function()
    local xPlayer = ESX.GetPlayerData()
    if xPlayer.job.name == 'police' then
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
    else
        TriggerEvent('zeon_notify:ShowNotification', "No eres policia", "Aviso")
    end
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
                TriggerServerEvent('zeon_refuerzos:setRef', 52, CurrentAsignation)

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
                    TriggerServerEvent('zeon_refuerzos:setRef', 11, CurrentAsignation)

                    ExecuteCommand('rpol [LSPD] - ['..CurrentAsignation.. "] inicia un 254-V a un "..fmodel.. " con matrícula "..fplate.. " por la zona de "..plyl..". Activamos referencias.")
            else
            end
        end, function(data, menu)
            menu.close()
        end
    )
end

---Copyright 2022 |-| ZeonFlux#4424 ----
