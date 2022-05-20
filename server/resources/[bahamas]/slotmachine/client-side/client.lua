-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("slotmachine",cRP)
vSERVER = Tunnel.getInterface("slotmachine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SLOTMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
local slotMachine = {
	[1] = {
		pos = vector3(1101.323,232.4321,-50.84092),
		bet = 1000,
		prop = "vw_prop_casino_slot_07a",
		prop1 = "vw_prop_casino_slot_07a_reels",
		prop2 = "vw_prop_casino_slot_07b_reels"
	},
	[2] = {
		pos = vector3(1108.005,233.9177,-50.84093),
		bet = 1000,
		prop = "vw_prop_casino_slot_07a",
		prop1 = "vw_prop_casino_slot_07a_reels",
		prop2 = "vw_prop_casino_slot_07b_reels",
	},
	[3] = {
		pos = vector3(1112.999,239.4742,-50.84093),
		bet = 1000,
		prop = "vw_prop_casino_slot_07a",
		prop1 = "vw_prop_casino_slot_07a_reels",
		prop2 = "vw_prop_casino_slot_07b_reels",
	},
	[4] = {
		pos = vector3(1116.662,228.8896,-50.84093),
		bet = 1000,
		prop = "vw_prop_casino_slot_07a",
		prop1 = "vw_prop_casino_slot_07a_reels",
		prop2 = "vw_prop_casino_slot_07b_reels",
	},
	[5] = {
		pos = vector3(1130.376,250.3577,-52.04094),
		bet = 1000,
		prop = "vw_prop_casino_slot_07a",
		prop1 = "vw_prop_casino_slot_07a_reels",
		prop2 = "vw_prop_casino_slot_07b_reels",
	},
	[6] = {
		pos = vector3(1138.07,252.6677,-52.04095),
		bet = 1000,
		prop = "vw_prop_casino_slot_07a",
		prop1 = "vw_prop_casino_slot_07a_reels",
		prop2 = "vw_prop_casino_slot_07b_reels",
	},
	[7] = {
		pos = vector3(1104.302,230.3183,-50.84093),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[8] = {
		pos = vector3(1100.939,231.0017,-50.84092),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[9] = {
		pos = vector3(1109.214,234.7699,-50.84093),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[10] = {
		pos = vector3(1111.716,238.7384,-50.84093),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[11] = {
		pos = vector3(1113.37,234.5486,-50.84093),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[12] = {
		pos = vector3(1117.871,229.7419,-50.84093),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[13] = {
		pos = vector3(1121.592,230.4106,-50.84092),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[14] = {
		pos = vector3(1131.655,249.6264,-52.04094),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[15] = {
		pos = vector3(1134.556,257.2778,-52.04095),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[16] = {
		pos = vector3(1139,251.7306,-52.04095),
		bet = 750,
		prop = "vw_prop_casino_slot_05a",
		prop1 = "vw_prop_casino_slot_05a_reels",
		prop2 = "vw_prop_casino_slot_05b_reels",
	},
	[17] = {
		pos = vector3(1101.221,231.6943,-50.84092),
		bet = 500,
		prop = "vw_prop_casino_slot_06a",
		prop1 = "vw_prop_casino_slot_06a_reels",
		prop2 = "vw_prop_casino_slot_06b_reels",
	},
	[18] = {
		pos = vector3(1108.919,233.9048,-50.84093),
		bet = 500,
		prop = "vw_prop_casino_slot_06a",
		prop1 = "vw_prop_casino_slot_06a_reels",
		prop2 = "vw_prop_casino_slot_06b_reels",
	},
	[19] = {
		pos = vector3(1112.407,239.0216,-50.84093),
		bet = 500,
		prop = "vw_prop_casino_slot_06a",
		prop1 = "vw_prop_casino_slot_06a_reels",
		prop2 = "vw_prop_casino_slot_06b_reels",
	},
	[20] = {
		pos = vector3(1117.576,228.8767,-50.84093),
		bet = 500,
		prop = "vw_prop_casino_slot_06a",
		prop1 = "vw_prop_casino_slot_06a_reels",
		prop2 = "vw_prop_casino_slot_06b_reels",
	},
	[21] = {
		pos = vector3(1131.062,250.0776,-52.04094),
		bet = 500,
		prop = "vw_prop_casino_slot_06a",
		prop1 = "vw_prop_casino_slot_06a_reels",
		prop2 = "vw_prop_casino_slot_06b_reels",
	},
	[22] = {
		pos = vector3(1138.195,251.8611,-52.04094),
		bet = 500,
		prop = "vw_prop_casino_slot_06a",
		prop1 = "vw_prop_casino_slot_06a_reels",
		prop2 = "vw_prop_casino_slot_06b_reels",
	},
	[23] = {
		pos = vector3(1105.486,229.4322,-50.84093),
		bet = 250,
		prop = "vw_prop_casino_slot_03a",
		prop1 = "vw_prop_casino_slot_03a_reels",
		prop2 = "vw_prop_casino_slot_03b_reels",
	},
	[24] = {
		pos = vector3(1110.229,238.7428,-50.84093),
		bet = 250,
		prop = "vw_prop_casino_slot_03a",
		prop1 = "vw_prop_casino_slot_03a_reels",
		prop2 = "vw_prop_casino_slot_03b_reels",
	},
	[25] = {
		pos = vector3(1114.554,233.6625,-50.84093),
		bet = 250,
		prop = "vw_prop_casino_slot_03a",
		prop1 = "vw_prop_casino_slot_03a_reels",
		prop2 = "vw_prop_casino_slot_03b_reels",
	},
	[26] = {
		pos = vector3(1120.853,231.6886,-50.84092),
		bet = 250,
		prop = "vw_prop_casino_slot_03a",
		prop1 = "vw_prop_casino_slot_03a_reels",
		prop2 = "vw_prop_casino_slot_03b_reels",
	},
	[27] = {
		pos = vector3(1132.396,248.3382,-52.04094),
		bet = 250,
		prop = "vw_prop_casino_slot_03a",
		prop1 = "vw_prop_casino_slot_03a_reels",
		prop2 = "vw_prop_casino_slot_03b_reels",
	},
	[28] = {
		pos = vector3(1133.952,256.1037,-52.04095),
		bet = 250,
		prop = "vw_prop_casino_slot_03a",
		prop1 = "vw_prop_casino_slot_03a_reels",
		prop2 = "vw_prop_casino_slot_03b_reels",
	},
	[29] = {
		pos = vector3(1104.572,229.4451,-50.84093),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[30] = {
		pos = vector3(1100.483,230.4082,-50.84092),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[31] = {
		pos = vector3(1108.482,235.3176,-50.84093),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[32] = {
		pos = vector3(1110.974,238.642,-50.84093),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[33] = {
		pos = vector3(1113.64,233.6755,-50.84093),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[34] = {
		pos = vector3(1117.139,230.2895,-50.84093),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[35] = {
		pos = vector3(1121.135,230.9999,-50.84092),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[36] = {
		pos = vector3(1132.109,249.0355,-52.04094),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[37] = {
		pos = vector3(1133.827,256.9098,-52.04095),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[38] = {
		pos = vector3(1139.372,252.4563,-52.04095),
		bet = 125,
		prop = "vw_prop_casino_slot_04a",
		prop1 = "vw_prop_casino_slot_04a_reels",
		prop2 = "vw_prop_casino_slot_04b_reels",
	},
	[39] = {
		pos = vector3(1105.781,230.2973,-50.84093),
		bet = 1000,
		prop = "vw_prop_casino_slot_02a",
		prop1 = "vw_prop_casino_slot_02a_reels",
		prop2 = "vw_prop_casino_slot_02b_reels",
	},
	[40] = {
		pos = vector3(1109.536,239.0278,-50.84093),
		bet = 1000,
		prop = "vw_prop_casino_slot_02a",
		prop1 = "vw_prop_casino_slot_02a_reels",
		prop2 = "vw_prop_casino_slot_02b_reels",
	},
	[41] = {
		pos = vector3(1114.848,234.5277,-50.84093),
		bet = 1000,
		prop = "vw_prop_casino_slot_02a",
		prop1 = "vw_prop_casino_slot_02a_reels",
		prop2 = "vw_prop_casino_slot_02b_reels",
	},
	[42] = {
		pos = vector3(1120.753,232.4274,-50.84092),
		bet = 1000,
		prop = "vw_prop_casino_slot_02a",
		prop1 = "vw_prop_casino_slot_02a_reels",
		prop2 = "vw_prop_casino_slot_02b_reels",
	},
	[43] = {
		pos = vector3(1132.492,247.5984,-52.04094),
		bet = 1000,
		prop = "vw_prop_casino_slot_02a",
		prop1 = "vw_prop_casino_slot_02a_reels",
		prop2 = "vw_prop_casino_slot_02b_reels",
	},
	[44] = {
		pos = vector3(1134.759,255.9734,-52.04095),
		bet = 1000,
		prop = "vw_prop_casino_slot_02a",
		prop1 = "vw_prop_casino_slot_02a_reels",
		prop2 = "vw_prop_casino_slot_02b_reels",
	},
	[45] = {
		pos = vector3(1105.049,230.845,-50.84093),
		bet = 1250,
		prop = "vw_prop_casino_slot_01a",
		prop1 = "vw_prop_casino_slot_01a_reels",
		prop2 = "vw_prop_casino_slot_01b_reels",
	},
	[46] = {
		pos = vector3(1105.049,230.845,-50.84093),
		bet = 1250,
		prop = "vw_prop_casino_slot_01a",
		prop1 = "vw_prop_casino_slot_01a_reels",
		prop2 = "vw_prop_casino_slot_01b_reels",
	},
	[47] = {
		pos = vector3(1108.938,239.4797,-50.84093),
		bet = 1250,
		prop = "vw_prop_casino_slot_01a",
		prop1 = "vw_prop_casino_slot_01a_reels",
		prop2 = "vw_prop_casino_slot_01b_reels",
	},
	[48] = {
		pos = vector3(1114.117,235.0753,-50.84093),
		bet = 1250,
		prop = "vw_prop_casino_slot_01a",
		prop1 = "vw_prop_casino_slot_01a_reels",
		prop2 = "vw_prop_casino_slot_01b_reels",
	},
	[49] = {
		pos = vector3(1120.853,233.1621,-50.84092),
		bet = 1250,
		prop = "vw_prop_casino_slot_01a",
		prop1 = "vw_prop_casino_slot_01a_reels",
		prop2 = "vw_prop_casino_slot_01b_reels",
	},
	[50] = {
		pos = vector3(1135.132,256.699,-52.04095),
		bet = 1250,
		prop = "vw_prop_casino_slot_01a",
		prop1 = "vw_prop_casino_slot_01a_reels",
		prop2 = "vw_prop_casino_slot_01b_reels",
	},
	[51] = {
		pos = vector3(1101.229,233.1719,-50.84092),
		bet = 250,
		prop = "vw_prop_casino_slot_08a",
		prop1 = "vw_prop_casino_slot_08a_reels",
		prop2 = "vw_prop_casino_slot_08b_reels",
	},
	[52] = {
		pos = vector3(1107.735,234.7909,-50.84093),
		bet = 250,
		prop = "vw_prop_casino_slot_08a",
		prop1 = "vw_prop_casino_slot_08a_reels",
		prop2 = "vw_prop_casino_slot_08b_reels",
	},
	[53] = {
		pos = vector3(1116.392,229.7628,-50.84093),
		bet = 250,
		prop = "vw_prop_casino_slot_08a",
		prop1 = "vw_prop_casino_slot_08a_reels",
		prop2 = "vw_prop_casino_slot_08b_reels",
	},
	[54] = {
		pos = vector3(1129.64,250.451,-52.04094),
		bet = 250,
		prop = "vw_prop_casino_slot_08a",
		prop1 = "vw_prop_casino_slot_08a_reels",
		prop2 = "vw_prop_casino_slot_08b_reels",
	},
	[55] = {
		pos = vector3(1138.799,253.0363,-52.04095),
		bet = 250,
		prop = "vw_prop_casino_slot_08a",
		prop1 = "vw_prop_casino_slot_08a_reels",
		prop2 = "vw_prop_casino_slot_08b_reels",
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Slots = {}
local Spins = {}
local Spinning = false
local selectedSlot = nil
local enterCasino = false
local currentSitting = nil
local currentChairData = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADENTERCASINO
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k,v in pairs(slotMachine) do
		createSlots(k,v)
	end

	while true do
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(1121.45,239.46,-50.45))
			if distance <= 25 then
				if not enterCasino then
					enterCasino = true
				end
			else
				if enterCasino then
					enterCasino = false
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATESLOTS
-----------------------------------------------------------------------------------------------------------------------------------------
createSlots = function(index,data)
	local self = {}

	self.data = data
	self.spin1 = nil
	self.spin2 = nil
	self.spin3 = nil
	self.spin1b = nil
	self.spin2b = nil
	self.spin3b = nil
	self.index = index

	self.tableObject = GetClosestObjectOfType(data.pos,0.8,GetHashKey(self.data.prop),0,0,0)
	self.offset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject),GetEntityHeading(self.tableObject),0.0,0.05,0.0)
	self.data.rot = GetEntityHeading(self.tableObject)

	self.startPlaying = function(state)
		if state then
			local aHash = "anim_casino_a@amb@casino@games@slots@female"

			RequestAnimDict(aHash)
			while not HasAnimDictLoaded(aHash) do
				Wait(1)
			end

			local rot = currentChairData.rotation + vector3(0.0,0.0,-90.0)
			currentSitting = NetworkCreateSynchronisedScene(self.offset,rot,2,1,0,1065353216,0,1065353216)
			NetworkAddPedToSynchronisedScene(PlayerPedId(),currentSitting,aHash,"base_idle_a",2.0,2.0,13,16,2.0,0)
			NetworkStartSynchronisedScene(currentSitting)

			model = GetHashKey(self.data.prop1)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(1)
			end

			model = GetHashKey(self.data.prop2)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(1)
			end

			local rot = vector3(0.0,0.0,self.data.rot + 0.0)
			local Offset = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject),GetEntityHeading(self.tableObject),0.0,-0.5,0.6)

			local Offset1 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject),GetEntityHeading(self.tableObject),-0.118,0.05,0.9)
			local Offset2 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject),GetEntityHeading(self.tableObject),0.000,0.05,0.9)
			local Offset3 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject),GetEntityHeading(self.tableObject),0.118,0.05,0.9)

			selectedSlot = self.index

			self.spin1 = CreateObject(GetHashKey(self.data.prop1),Offset1.x,Offset1.y,Offset1.z,false,false)
			self.spin2 = CreateObject(GetHashKey(self.data.prop1),Offset2.x,Offset2.y,Offset2.z,false,false)
			self.spin3 = CreateObject(GetHashKey(self.data.prop1),Offset3.x,Offset3.y,Offset3.z,false,false)

			table.insert(Spins,self.spin1)
			table.insert(Spins,self.spin2)
			table.insert(Spins,self.spin3)

			SetEntityHeading(self.spin1,self.data.rot)
			SetEntityHeading(self.spin2,self.data.rot)
			SetEntityHeading(self.spin3,self.data.rot)

			CreateThread(function()
				while selectedSlot ~= nil do
					Wait(1)

					if IsDisabledControlJustPressed(0,194) then
						if not Spinning then
							DeleteEntity(self.spin1)
							DeleteEntity(self.spin2)
							DeleteEntity(self.spin3)

							self.startPlaying(false)

							self.spin1 = GetClosestObjectOfType(Offset.x - 0.118,Offset.y,Offset.z,1.0,GetHashKey(self.data.prop1),false,false,false)
							self.spin2 = GetClosestObjectOfType(Offset.x + 0.000,Offset.y,Offset.z,1.0,GetHashKey(self.data.prop1),false,false,false)
							self.spin3 = GetClosestObjectOfType(Offset.x + 0.118,Offset.y,Offset.z,1.0,GetHashKey(self.data.prop1),false,false,false)
						end
					end

					if IsDisabledControlJustPressed(0,191) or IsDisabledControlJustPressed(0,22) then
						if not Spinning then
							Spinning = true

							if Slots[self.index] then
								TriggerServerEvent("slotmachine:taskStartSlots",self.index,self.data)
							end

							self.spin1 = GetClosestObjectOfType(Offset.x - 0.118,Offset.y,Offset.z,1.0,GetHashKey(self.data.prop1),false,false,false)
							self.spin2 = GetClosestObjectOfType(Offset.x + 0.000,Offset.y,Offset.z,1.0,GetHashKey(self.data.prop1),false,false,false)
							self.spin3 = GetClosestObjectOfType(Offset.x + 0.118,Offset.y,Offset.z,1.0,GetHashKey(self.data.prop1),false,false,false)

							Wait(5000)
						end
					end
				end
			end)

			Wait(1000)
		else
			selectedSlot = nil

			local aHash = "anim_casino_a@amb@casino@games@slots@female"

			RequestAnimDict(aHash)
			while not HasAnimDictLoaded(aHash) do
				Wait(1)
			end

			local rot = currentChairData.rotation + vector3(0.0,0.0,-90.0)
			currentSitting = NetworkCreateSynchronisedScene(self.offset,rot,2,1,0,1065353216,0,1065353216)
			NetworkAddPedToSynchronisedScene(PlayerPedId(),currentSitting,aHash,"exit_left",2.0,2.0,13,16,0,0)
			NetworkStartSynchronisedScene(currentSitting)

			Wait(3000)

			ClearPedTasks(PlayerPedId())
			TriggerServerEvent("slotmachine:notUsing",self.index)
		end
	end

	self.spin = function(tickRate)
		local aHash = "anim_casino_a@amb@casino@games@slots@female"

		RequestAnimDict(aHash)
		while not HasAnimDictLoaded(aHash) do
			Wait(1)
		end

		local rot = currentChairData.rotation + vector3(0.0,0.0,-90.0)
		currentSitting = NetworkCreateSynchronisedScene(self.offset,rot,2,1,0,1065353216,0,1065353216)
		NetworkAddPedToSynchronisedScene(PlayerPedId(),currentSitting,aHash,"press_spin_a",2.0,2.0,50,16,2.0,0)
		NetworkStartSynchronisedScene(currentSitting)

		Wait(500)

		DeleteEntity(self.spin1)
		DeleteEntity(self.spin2)
		DeleteEntity(self.spin3)

		local Offset1 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject),GetEntityHeading(self.tableObject),-0.118,0.05,0.9)
		local Offset2 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject),GetEntityHeading(self.tableObject),0.000,0.05,0.9)
		local Offset3 = GetObjectOffsetFromCoords(GetEntityCoords(self.tableObject),GetEntityHeading(self.tableObject),0.118,0.05,0.9)

		self.spin1b = CreateObject(GetHashKey(self.data.prop2),Offset1.x,Offset1.y,Offset1.z,false,false)
		self.spin2b = CreateObject(GetHashKey(self.data.prop2),Offset2.x,Offset2.y,Offset2.z,false,false)
		self.spin3b = CreateObject(GetHashKey(self.data.prop2),Offset3.x,Offset3.y,Offset3.z,false,false)

		table.insert(Spins,self.spin1b)
		table.insert(Spins,self.spin2b)
		table.insert(Spins,self.spin3b)

		SetEntityHeading(self.spin1b,self.data.rot)
		SetEntityHeading(self.spin2b,self.data.rot)
		SetEntityHeading(self.spin3b,self.data.rot)

		local temp1 = GetEntityRotation(self.spin1b)
		local temp2 = GetEntityRotation(self.spin2b)
		local temp3 = GetEntityRotation(self.spin3b)

		SetEntityRotation(self.spin1b,temp1.x + math.random(0,360) - 180.0,temp1.y,temp1.z,0,true)
		SetEntityRotation(self.spin2b,temp2.x + math.random(0,360) - 180.0,temp2.y,temp2.z,0,true)
		SetEntityRotation(self.spin3b,temp3.x + math.random(0,360) - 180.0,temp3.y,temp3.z,0,true)

		for i = 1,300,1 do
			local h1 = GetEntityRotation(self.spin1b)
			local h2 = GetEntityRotation(self.spin2b)
			local h3 = GetEntityRotation(self.spin3b)

			if i < 180 then
				SetEntityRotation(self.spin1b,h1.x + math.random(40,100) / 10,h1.y,h1.z,1,true)
			elseif i == 180 then
				h1 = GetEntityRotation(self.spin1b)
				DeleteEntity(self.spin1b)

				self.spin1 = CreateObject(GetHashKey(self.data.prop1),Offset1.x,Offset1.y,Offset1.z,false,false)
				table.insert(Spins,self.spin1)
				SetEntityHeading(self.spin1,self.data.rot)
				SetEntityRotation(self.spin1,tickRate.a * 22.5 - 180 + 0.0,h1.y,h1.z,1,false)
			end

			if i < 240 then
				SetEntityRotation(self.spin2b,h2.x + math.random(40,100) / 10,h2.y,h2.z,1,true)
			elseif i == 240 then
				h2 = GetEntityRotation(self.spin2b)
				DeleteEntity(self.spin2b)
				self.spin2 = CreateObject(GetHashKey(self.data.prop1),Offset2.x,Offset2.y,Offset2.z,false,false)
				table.insert(Spins,self.spin2)
				SetEntityHeading(self.spin2,self.data.rot)
				SetEntityRotation(self.spin2,tickRate.b * 22.5 - 180 + 0.0,h2.y,h2.z,1,false)
			end

			if i < 300 then
				SetEntityRotation(self.spin3b,h3.x + math.random(40,100) / 10,h3.y,h3.z,1,true)
			elseif i == 300 then
				h3 = GetEntityRotation(self.spin3b)
				DeleteEntity(self.spin3b)
				self.spin3 = CreateObject(GetHashKey(self.data.prop1),Offset3.x,Offset3.y,Offset3.z,false,false)
				table.insert(Spins,self.spin3)
				SetEntityHeading(self.spin3,self.data.rot)
				SetEntityRotation(self.spin3,tickRate.c * 22.5 - 180 + 0.0,h3.y,h3.z,1,false)
				NetworkAddPedToSynchronisedScene(PlayerPedId(),currentSitting,"anim_casino_b@amb@casino@games@shared@player@","idle_a",2.0,2.0,50,16,2.0,0)
				NetworkStartSynchronisedScene(currentSitting)
			end

			Wait(10)
		end

		Spinning = false

		TriggerServerEvent("slotmachine:slotsCheckWin",self.index,tickRate,self.data)
	end

	Slots[self.index] = self
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTSPIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("slotmachine:startSpin")
AddEventHandler("slotmachine:startSpin",function(index,tickRate)
	if Slots[index] ~= nil then
		Slots[index].spin(tickRate)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local timeDistance = 999
		if enterCasino and selectedSlot == nil then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)

			for k,v in pairs(Slots) do
				if DoesEntityExist(v.tableObject) then
					local objCoords = GetEntityCoords(v.tableObject)
					local distance = #(coords - objCoords)
					if distance <= 2 then
						timeDistance = 1

						local closestChairData = getClosestChairData(v.tableObject)
						if closestChairData == nil then
							break
						end

						DrawMarker(20,closestChairData.position + vector3(0.0,0.0,1.0),0.0,0.0,0.0,180.0,0.0,0.0,0.3,0.3,0.3,255,255,255,255,true,true,2,true,nil,nil,false)

						if IsControlJustPressed(0,176) then
							currentChairData = closestChairData
							currentSitting = NetworkCreateSynchronisedScene(closestChairData.position,closestChairData.rotation,2,1,0,1065353216,0,1065353216)

							local aHash = "anim_casino_b@amb@casino@games@shared@player@"
							RequestAnimDict(aHash)
							while not HasAnimDictLoaded(aHash) do
								Wait(1)
							end

							NetworkAddPedToSynchronisedScene(PlayerPedId(),currentSitting,"anim_casino_b@amb@casino@games@shared@player@","sit_enter_left",2.0,-2.0,13,16,2.0,0)
							TriggerServerEvent("slotmachine:isSeatUsed",v.index)
							NetworkStartSynchronisedScene(currentSitting)

							if Slots[k] then
								Slots[k].startPlaying(true)
							end
						end

						break
					end
				else
					for k,v in pairs(slotMachine) do
						createSlots(k,v)
					end
				end
			end
		end

		Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCLOSESTCHAIRDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function getClosestChairData(tableObject)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	if DoesEntityExist(tableObject) then
		local objCoords = GetWorldPositionOfEntityBone(tableObject,GetEntityBoneIndexByName(tableObject,"Chair_Base_01"))
		local distance = #(coords - objCoords)
		if distance <= 1.5 then
			return { position = objCoords, rotation = GetWorldRotationOfEntityBone(tableObject,GetEntityBoneIndexByName(tableObject,"Chair_Base_01")), chairId = 1, obj = tableObject }
		end
	end
end