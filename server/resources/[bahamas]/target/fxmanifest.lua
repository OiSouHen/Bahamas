fx_version "bodacious"
game "gta5"

dependencies {
    "PolyZone"
}

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/EntityZone.lua",
	"@PolyZone/CircleZone.lua",
	"@PolyZone/ComboZone.lua",
	"client-side/*"
}

files {
	"web-side/*"
}