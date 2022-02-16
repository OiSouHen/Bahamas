-----------------------------------------------------------------------------------------------------------------------------------------
-- SUGGESTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local suggestions = {
	{
		name = "/debug",
		help = "Recarrega todas as configurações do personagem."
	},{
		name = "/vehs",
		help = "Visualiza todos os seus veículos."
	},{
		name = "/limbo",
		help = "Reaparecer o personagem na rua mais próxima."
	},{
		name = "/roupas",
		help = "Visualiza todos os outfits da propriedade."
	},{
		name = "/hud",
		help = "Mostra/Esconde a interface na tela."
	},{
		name = "/movie",
		help = "Mostra/Esconde a interface de video na tela."
	},{
		name = "/911",
		help = "Chat de conversa da policia."
	},{
		name = "/me",
		help = "Ativar uma animação não existente."
	},{
		name = "/volume",
		help = "Muda o volume do rádio.",
		params = {
			{ name = "número", help = "De 0 a 100 - Padrão: 60" }
		}
	},{
		name = "/chat",
		help = "Ativa/Desativa o chat."
	},{
		name = "/cam",
		help = "Visualiza uma câmera escolhida.",
		params = {
			{ name = "número", help = "Número da câmera" }
		}
	},{
		name = "/setrepose",
		help = "Adiciona o repouso na pessoa mais próxima.",
		params = {
			{ name = "minutos", help = "Quantidade de minutos." }
		}
	},{
		name = "/112",
		help = "Chat de conversa dos paramédicos."
	},{
		name = "/andar",
		help = "Muda o estilo de andar.",
		params = {
			{ name = "número", help = "De 1 a 59" }
		}
	},{
		name = "/e",
		help = "Inicia uma animação a sua escolha.",
		params = {
			{ name = "nome", help = "Nome da animação" }
		}
	},{
		name = "/e2",
		help = "Inicia uma animação a sua escolha.",
		params = {
			{ name = "nome", help = "Nome da animação" }
		}
	},{
		name = "/evidence",
		help = "Inicia o teste de evidências no microscópio do hospital.",
		params = {
			{ name = "serial", help = "Serial de evidência" }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("chat:addSuggestion",source,suggestions)
end)