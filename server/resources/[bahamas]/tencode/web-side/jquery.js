/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["tencode"] == true){
			$("#divCode").css("display","block");
		}

		if (event["data"]["tencode"] == false){
			$("#divCode").css("display","none");
		}

		if (event["data"]["radar"] == true){
			$("#divRadar").css("display","block");
		}

		if (event["data"]["radar"] == false){
			$("#divRadar").css("display","none");
		}

		if (event["data"]["radar"] == "top"){
			$("#topRadar").html("<c>PLACA:</c> "+ event["data"]["plate"] +"     <c>MODELO:</c> "+ event["data"]["model"] +"     <c>VELOCIDADE:</c> "+ parseInt(event["data"]["speed"]) +" KMH");
		}

		if (event["data"]["radar"] == "bot"){
			$("#botRadar").html("<c>PLACA:</c> "+ event["data"]["plate"] +"     <c>MODELO:</c> "+ event["data"]["model"] +"     <c>VELOCIDADE:</c> "+ parseInt(event["data"]["speed"]) +" KMH");
		}
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://tencode/closeSystem");
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
const clickCode = (data) => {
	$.post("http://tencode/sendCode",JSON.stringify({ code: data }));
};