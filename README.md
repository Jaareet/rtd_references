# rtd_refuerzos

- add this to your `esx_rpchat` `server-side`

```

RegisterCommand('rpol', function(source, args, rawCommand)
    if source == 0 then
        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == "police" then
        args = table.concat(args, ' ')
        local name = GetPlayerName(source)
		local job = GetPjWork(source)
        if Config.EnableESXIdentity then name = GetPjName(source) end
        for k,v in ipairs(ESX.GetPlayers()) do
            local p = ESX.GetPlayerFromId(v)
            if p.job.name == "police" then
                TriggerClientEvent('chat:addMessage', -1, { args = { _U('rpol_prefix', job, name), args }, color = { 255, 255, 255 } })
            end
        end
    end
end, false)

```

```

function GetPjName(source)
    local Player = ESX.GetPlayerFromId(source)
    local name = Player.getName()
	
	return name
end

function GetPjWork(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local job = xPlayer.job.grade_label

	return job
end

```

- add this to your `locales`

```

  ['rpol_prefix'] = '^5[^*^0SAPD^*^r^5] %s %s ^5',

```

## EXTRA

- server/main.lua linea 44 (Pueden cambiar el tiempo que toma a el blip actualizarse, Afecta el resmon !)