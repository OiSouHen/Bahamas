$(document).ready(function(){
	var percent = 0;

	document.onkeydown = function (data){
		if (data["which"] == 69){
			$.post("http://taskbar/taskEnd",JSON.stringify({ taskResult: percent }));
			$(".divwrap").css("display","none");
		}
	}

	window.addEventListener("message",function(event){
		var item = event["data"];

		if (item["runProgress"] === true){
			percent = 0;

			$("#progress-bar").css("width","0");
			$(".divwrap").css("display","block");
			$(".skillprogress").css("left",item["chance"] + "%")
			$(".skillprogress").css("width",item["skillGap"] + "%");
		}

		if (item["runUpdate"] === true){
			percent = item["Length"];

			$("#progress-bar").css("width",item["Length"] + "%");

			if (item["Length"] < (item["chance"] + item["skillGap"]) && item["Length"] > (item["chance"])){
				$(".skillprogress").css("background-color","#6b3434");
			} else {
				$(".skillprogress").css("background-color","#62587e");
			}
		}

		if (item["closeProgress"] === true){
			$(".divwrap").css("display","none");
		}
	});
});