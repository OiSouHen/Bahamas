---------------------------------------------------------------------
RegisterServerEvent("lvc_TogDfltSrnMuted_s")
AddEventHandler("lvc_TogDfltSrnMuted_s",function(newstate,playerAround)
	local source = source

	if playerAround then
		for _,v in ipairs(playerAround) do
			async(function()
				TriggerClientEvent("lvc_TogDfltSrnMuted_c",v,source,newstate)
			end)
		end	
	end
end)
---------------------------------------------------------------------
RegisterServerEvent("lvc_SetLxSirenState_s")
AddEventHandler("lvc_SetLxSirenState_s", function(newstate,playerAround)
	local source = source

	if playerAround then
		for _,v in ipairs(playerAround) do
			async(function()
				TriggerClientEvent("lvc_SetLxSirenState_c",v,source,newstate)
			end)
		end	
	end
end)
---------------------------------------------------------------------
RegisterServerEvent("lvc_SetAirManuState_s")
AddEventHandler("lvc_SetAirManuState_s", function(newstate,playerAround)
	local source = source

	if playerAround then
		for _,v in ipairs(playerAround) do
			async(function()
				TriggerClientEvent("lvc_SetAirManuState_c",v,source,newstate)
			end)
		end	
	end
end)