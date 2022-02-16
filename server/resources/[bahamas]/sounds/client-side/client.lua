RegisterNetEvent("sounds:source")
AddEventHandler("sounds:source",function(sound,volume)
	SendNUIMessage({ transactionType = "playSound", transactionFile = sound, transactionVolume = volume })
end)

RegisterNetEvent("sounds:distance")
AddEventHandler("sounds:distance",function(sCoords,maxDistance,sound,volume)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local distance = #(coords - sCoords)

	if distance <= maxDistance then
		SendNUIMessage({ transactionType = "playSound", transactionFile = sound, transactionVolume = volume })
	end
end)