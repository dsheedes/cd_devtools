local resource_name, saved_resource = GetCurrentResourceName()

local function ConsolePrint(action, message)
    local colour
    if action == 'success' then
        colour = '^3'
    elseif action == 'error' then
        colour = '^1'
    end
    print(colour..'['..resource_name..'] - '..message..'^0')
end

Citizen.CreateThread(function()
    local data = LoadResourceFile(resource_name, './restart_script.txt')
    if data ~= nil then
        if #data > 0 then
            saved_resource = data
            ConsolePrint('success', 'Saved resource name cached.')
        else
            ConsolePrint('error', 'Saved resource name empty.')
        end
    else
        SaveResourceFile(resource_name, 'restart_script.txt', '', -1)
        ConsolePrint('error', 'restart_script.txt file missing, automatically fixed.')
    end
end)

RegisterCommand('restart_script', function(source, args)
    if args[1] then
        SaveResourceFile(resource_name,'restart_script.txt', args[1], -1)
        ConsolePrint('success', 'Resource name saved and updated.')
        saved_resource = args[1]
    else
        ConsolePrint('error', 'Enter resource name in 1st argument.')
    end
end)

RegisterServerEvent('cd_devtools:RestartScript')
AddEventHandler('cd_devtools:RestartScript', function()
    if saved_resource then
	    StopResource(saved_resource)
        Wait(500)
        StartResource(saved_resource)
        TriggerClientEvent('chat:addMessage', -1, {
            color = { 255, 0, 0},
            multiline = true,
            args = {'RESTART SCRIPT:', saved_resource..' has been restarted successfully'}
        })
    else
        ConsolePrint('error', 'Saved resource name is nil.')
    end
end)