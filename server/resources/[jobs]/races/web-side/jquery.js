$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["show"] !== undefined){
			if (event["data"]["show"] == true){
				$("#displayRunners").css("display","block");
			} else {
				$("#displayRunners").css("display","none");
			}

			return
		}

		$("#displayRunners").html(`
			CHECKPOINTS <s>${event["data"]["checkpoint"]} / ${event["data"]["maxcheckpoint"]}</s><br>
			PONTOS <s>${formatarNumero(parseInt(event["data"]["points"]))}</s>
		`);

		if (parseInt(event["data"]["explosive"]) > 0){
			$('#displayRunners').append(`<br>TEMPO <s>${formatarNumero(parseInt(event["data"]["explosive"]))}</s>`);
		}
	});
});
/* ----------FORMATARNUMERO---------- */
const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}