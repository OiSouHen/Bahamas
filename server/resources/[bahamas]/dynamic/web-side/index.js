$(document).ready(function (){
	const buttons = []
	const submenus = []

	document.onkeyup = function(data){
		if (data["which"] == 27){
			buttons["length"] = 0;
			submenus["length"] = 0;

			$.post("http://dynamic/close",JSON.stringify({}));
			$("button").remove();
			$("#title").html("");
		} else if(data["which"] == 8){
			$("button").remove();

			for (i = 0; i < buttons["length"]; ++i){
				var div = buttons[i];
				var match = div.match("normalbutton");
				if(match){
					$(".container").prepend(div);
				}
			}

			$(".container").append(submenus).show();
		}
	}

	window.addEventListener("message",function(event){
		var item = event["data"];

		if(item["addbutton"] == true){
			if(item.id == false || null){
				var b = (`<button id="normalbutton" data-trigger="`+item["trigger"]+`" data-parm="`+item["par"]+`" data-server="`+item["server"]+`" class="btn"><div class="title">`+item["title"]+`</div><div class="description" >`+item["description"]+`</div></button>`);
				buttons.push(b);
				return
			} else {
				var b = (`<button id="`+item["id"]+`"data-trigger="`+item["trigger"]+`" data-parm="`+item["par"]+`" data-server="`+item["server"]+`" class="a btn"><div class="title">`+item["title"]+`</div><div class="description" >`+item["description"]+`</div></button>`);
				buttons.push(b);
			}
		} else if(item["addmenu"] == true){
			var aa = (`<button data-menu="`+item["menuid"]+`"class="b btn"><div class="title">`+item["title"]+`</div><div class="description" >`+item["description"]+`</div><i class="fas fa-chevron-right" style="float:right;margin-top:-10%"></i></button>`)
			$(".container").append(aa);
			$(".container").show();
			submenus.push(aa);
		}

		if (item["close"] == true){
			buttons["length"] = 0;
			submenus["length"] = 0;
			$("button").remove();
			$("#title").html("");
		}
	});

	function goback(){
		var gobackbutton = (`<button style="height:10px; background: #241f34;" id="goback"class ="btn"><div class="title" style="margin-top:-3.8%">Voltar</div><i class="fas fa-chevron-left" style="float: right; margin-top:-3.5%"></i></button>`);
		$(".container").append(gobackbutton).show();
	}

	$("body").on("click",".a",function(){
		$.post("http://dynamic/clicked",JSON.stringify({ trigger:$(this).attr("data-trigger"), param:$(this).attr("data-parm"), server: $(this).attr("data-server") }));
	});

	$("body").on("click","#normalbutton",function(){
		$.post("http://dynamic/clicked",JSON.stringify({ trigger: $(this).attr("data-trigger"), param: $(this).attr("data-parm"), server: $(this).attr("data-server") }));
	});

	$("body").on("click",".b",function(){
		goback();

		$(".b").remove();
		$(".a").remove();
		$("#normalbutton").remove();

		var menuid = $(this).attr("data-menu");
		for (i = 0; i < buttons["length"]; ++i){
			var div = buttons[i];
			var match = div.match(`id="`+menuid+`"`);
			if(match) {
				$(".container").append(div);
			}
		}
	});

	$("body").on("click","[id=goback]",function(){
		$(".b").remove();
		$(".a").remove();
		$("button").remove();
		$(".container").append(submenus).show();

		for (i = 0; i < buttons["length"]; ++i){
			var div = buttons[i];
			var match = div.match("normalbutton");
			if(match){
				$(".container").append(div);
			}
		}
	});
});