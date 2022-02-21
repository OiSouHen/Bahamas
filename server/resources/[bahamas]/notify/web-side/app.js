$(document).ready(function(){
	var notifyNumber = 0;
	window.addEventListener("message",function(event){
		if (event["data"]["notify"] !== undefined){
			var html = `<div id='${event.data.css}'>
				${event["data"]["mensagem"]}
				<div class="timer-bar ${notifyNumber}"></div>
			</div>`;

			$(html).fadeIn(500).appendTo("#notifications").delay(event["data"]["timer"]).fadeOut(500);
			$(`.${notifyNumber}`).css("transition",`width ${event["data"]["timer"]}ms`);

			setTimeout(() => {
				$(`.${notifyNumber}`).css("width","0%");
				notifyNumber += 1;
			},100);
		}
	});
});