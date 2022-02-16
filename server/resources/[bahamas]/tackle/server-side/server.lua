-----------------------------------------------------------------------------------------------------------------------------------------
-- TACKLE:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tackle:Update")
AddEventHandler("tackle:Update",function(Tackled,ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
	TriggerClientEvent("tackle:Player",Tackled,ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
end)