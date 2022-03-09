$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["show"] !== undefined){
			if (event["data"]["show"] == true){
				$("#displayTimers").css("display","block");
			} else {
				$("#displayTimers").css("display","none");
			}
			return
		}

		$("#displayTimers").html(event["data"]["timer"] + "<legend>roubo em andamento, não se afaste</legend>");
	});
});