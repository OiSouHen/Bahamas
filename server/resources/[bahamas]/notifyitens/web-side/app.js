$(document).ready(function(){
	window.addEventListener("message",function(event){
		var html = `<div class="item" style="background-image: url('nui://inventory/web-side/images/${event.data.item}.png');">
			<div class="top">
				<div class="itemWeight">${event.data.mode}</div>
				<div class="itemAmount">${event.data.amount}x</div>
			</div>
			<div class="nameItem">${event.data.name}</div>
		</div>`;

		$(html).fadeIn(500).appendTo("#notifyitens").delay(3000).fadeOut(500);
	})
});