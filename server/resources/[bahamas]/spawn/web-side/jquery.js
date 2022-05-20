/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch (event["data"]["action"]){
			case "openSystem":
				$("#charPage").css("display","block");
				generateDisplay();
			break;

			case "closeSystem":
				$("#charPage").css("display","none");
			break;

			case "openSpawn":
				generateSpawn();
			break;

			case "closeNew":
				$("#charPage").css("display","none");
				$("#createPage").css("display","none");
			break;

			case "closeSpawn":
				$("#spawnPage").css("display","none");
			break;
		};
	});
});
/* ---------------------------------------------------------------------------------------------------------------- */
const generateDisplay = () => {
	$.post("http://spawn/generateDisplay",JSON.stringify({}),(data) => {

		var characterList = data["result"].sort((a,b) => (a["user_id"] > b["user_id"]) ? 1: -1);

		$("#charPage").html(`
			<div id="charNew"><b>Novo Personagem</b>Pressione para criar um novo personagem.</div>

			${characterList.map((item) => (`<div id="charBox" data-id="${item["user_id"]}">
				<b>Passaporte:</b> ${item["user_id"]}<br>
				<b>Nome:</b> ${item["name"]}
				<float>CONECTAR</float>
			</div>`)).join('')}
		`);
	});
}
/* ----------CHARBOX---------- */
$(document).on("click","#charBox",function(e){
	$.post("http://spawn/characterChosen",JSON.stringify({ id: parseInt(e["currentTarget"]["dataset"]["id"]) }));
	$("#charPage").css("display","none");
});
/* ----------CHARNEW---------- */
$(document).on("click","#charNew",function(e){
	$("#charPage").css("display","none");
	$("#createPage").css("display","block");
});
/* ----------CREATEBACK---------- */
$(document).on("click","#createBack",function(e){
	$("#charPage").css("display","block");
	$("#createPage").css("display","none");
});
/* ---------------------------------------------------------------------------------------------------------------- */
const generateSpawn = () => {
	$.post("http://spawn/generateSpawn",JSON.stringify({}),(data) => {

		var characterList = data["result"].sort((a,b) => (a["name"] > b["name"]) ? 1: -1);

		$("#spawnPage").html(`
			${characterList.map((item) => (`<div id="spawnBox" data-hash="${item["hash"]}">
				${item["name"]}
			</div>`)).join('')}

			<div id="spawnNew" data-hash="spawn">Confirmar</div>
		`);

		$("#spawnPage").css("display","block");
	});
}
/* ----------SPAWNBOX---------- */
$(document).on("click","#spawnBox",function(e){
	$.post("http://spawn/spawnChosen",JSON.stringify({ hash: parseInt(e["currentTarget"]["dataset"]["hash"]) }));
});
/* ----------SPAWNNEW---------- */
$(document).on("click","#spawnNew",function(e){
	$.post("http://spawn/spawnChosen",JSON.stringify({ hash: "spawn" }));
});
/* ----------CREATENEW---------- */
$(document).on("click","#createNew",function(e){
	var nome = $("#charNome").val();
	var sobrenome = $("#charSobrenome").val();
	var sexo = $("#charSexo").val();

	if (nome != "" && sobrenome != "" && (sexo == "M" || sexo == "F")){
		if (sexo == "M"){ sexo = "mp_m_freemode_01" } else { sexo = "mp_f_freemode_01" }
		$.post("http://spawn/newCharacter",JSON.stringify({ name: nome, name2: sobrenome, sex: sexo }));
	}
});