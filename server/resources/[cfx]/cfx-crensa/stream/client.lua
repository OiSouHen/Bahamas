
local blips = {
  {title="Favela 1 brkk", colour=45, id=40, x = 1256.575, y = -115.3526, z = 71.10435},
  {title="Favela 2 brkk", colour=59, id=40, x = 2584.892, y = 2728.877, z = 42.9769},
}

local coefflouze = 0.1 --Coeficient multiplicateur qui en fonction de la distance definit la paie

--INIT--

local isInJobMec = false
local livr = 0
local plateab = "POPJOBS"
local isToHouse = false
local isToMcdonalds = false
local paie = 0

local pourboire = 0
local posibilidad = 0
local px = 0
local py = 0
local pz = 0

--THREADS--

CreateThread(function() --Thread d'ajout du point de la mcdonalds sur la carte

  for _, info in pairs(blips) do

    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.9)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
  end

end)