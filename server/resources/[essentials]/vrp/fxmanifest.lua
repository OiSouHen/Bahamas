fx_version "bodacious"
game "gta5"

ui_page "gui/index.html"

server_scripts {
	"lib/vehicles.lua",
	"lib/itemlist.lua",
	"lib/utils.lua",
	"modules/*"
}

client_scripts {
	"lib/vehicles.lua",
	"lib/itemlist.lua",
	"lib/utils.lua",
	"client/*"
}

files {
	"loading/*",
	"lib/*",
	"gui/*"
}

loadscreen "loading/index.html"