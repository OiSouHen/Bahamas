fx_version "bodacious"
game "gta5"

client_scripts {
	"@vrp/lib/utils.lua",
	"source/RMenu.lua",
	"source/menu/RageUI.lua",
	"source/menu/Menu.lua",
	"source/menu/MenuController.lua",
	"source/components/*.lua",
	"source/menu/elements/*.lua",
	"source/menu/items/*.lua",
	"source/menu/panels/*.lua",
	"source/menu/panels/*.lua",
	"source/menu/windows/*.lua",
	"client-side/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server-side/*"
}