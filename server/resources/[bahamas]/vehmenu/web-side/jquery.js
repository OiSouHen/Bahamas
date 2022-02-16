/* ----------EVENTLISTENER---------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){

		if (event["data"]["show"] == true){
			$("#vehicleBackground").fadeIn(250);
		}

		if (event["data"]["show"] == false){
			$("#vehicleBackground").fadeOut(250);
			$(".ui-tooltip").hide();
		}

	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://vehmenu/closeSystem");
		};
	};

	$(".populated").tooltip({
		create: function(event,ui){
			var texto = $(this).attr("data-texto");

			$(this).tooltip({
				content: texto,
				position: { my: "center top-74", at: "center" },
				show: { duration: 10 },
				hide: { duration: 10 }
			})
		}
	});
});
/* ----------MENUACTIVE---------- */
$(document).on("click",".vehicleButton",debounce(function(e){
	var name = e["currentTarget"]["dataset"]["name"];

	if (name == "close"){
		$.post("http://vehmenu/closeSystem");
	} else {
		$.post("http://vehmenu/menuActive",JSON.stringify({ active: name }));
	}
}));
/* ----------DEBOUNCE---------- */
function debounce(func,immediate){
	var timeout
	return function(){
		var context = this,args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,100)
		if (callNow) func.apply(context,args)
	}
}