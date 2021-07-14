local resource_name, saved_resource = GetCurrentResourceName()

Citizen.CreateThread(function()
    saved_resource = LoadResourceFile(resource_name,'./restart_script.txt')
    print('^3['..resource_name..'] - Saved Resource applied^0')
end)

RegisterCommand('restart_script', function(source, args)
    if args[1] then
        SaveResourceFile(resource_name,'restart_script.txt', args[1], -1)
        print('^3['..resource_name..'] - Resource Saved^0')
        saved_resource = args[1]
    else
        print('enter script name in 1st argument ape')
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
        print('saved_resource is nil')
    end
end)