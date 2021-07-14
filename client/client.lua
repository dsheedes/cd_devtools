Citizen.CreateThread(function()
	while true do
		Wait(5)
		if IsControlJustReleased(0, Config.Keys.toggle_nuifocus) then
			TriggerEvent('cd_devtools:ToggleNUIFocus')
		end

		if IsControlJustReleased(0, Config.Keys.restart_script) then
			TriggerServerEvent('cd_devtools:RestartScript')
		end
	end
end)

--credits https://stackoverflow.com/a/41943392 (google is for more than just porn!)
local function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", 0) .. "{\r\n"
	indent = indent + 2 
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
			toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
			toprint = toprint  .. k ..  " = "   
		end
		if (type(v) == "number") then
			toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
			toprint = toprint .. tprint(v, indent + 1) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end

local ui_open, last_table = false, ''
RegisterNetEvent('table')
AddEventHandler('table', function(data)
	if type(data) == 'table' then
		local string_table = tprint(data)
		if not ui_open then
			ui_open = true
			SendNUIMessage({
			action = 'show',
			data = data,
			tprint = string_table
			})
			TriggerEvent('cd_devtools:ToggleNUIFocus')
		elseif string_table ~= last_table then
			SendNUIMessage({
			action = 'update',
			data = data,
			tprint = string_table
			})
		end
		last_table = string_table
	else
		print('table is nil')
	end
end)

local NUI_status = false
RegisterNetEvent('cd_devtools:ToggleNUIFocus')
AddEventHandler('cd_devtools:ToggleNUIFocus', function()
	if NUI_status or not ui_open then NUI_status = false return end
    NUI_status = true
    while NUI_status do
        SetNuiFocus(NUI_status, NUI_status)
		Wait(100)
    end
    SetNuiFocus(false, false)
end)

RegisterNUICallback('close', function(data)
	NUI_status = false
	if data.closed then
		ui_open = false
	end
end)