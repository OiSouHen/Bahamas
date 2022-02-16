var selectShop = "selectShop";
var selectType = "Buy";
/* --------------------------------------------------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch(event.data.action){
			case "showNUI":
				selectShop = event.data.name;
				selectType = event.data.type;
				$(".inventory").css("display","flex");
				requestShop();
			break;

			case "hideNUI":
				$(".inventory").css("display","none");
				$(".ui-tooltip").hide();
			break;

			case "requestShop":
				requestShop();
			break;
		}
	});

	document.onkeyup = data => {
		if (data["key"] === "Escape"){
			$.post("http://shops/close");
			$(".invRight").html("");
			$(".invLeft").html("");
		}
	}
});
/* --------------------------------------------------- */
const updateDrag = () => {
	$(".populated").draggable({
		helper: "clone"
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let amount = $(".amount").val();
			if (shiftPressed) amount = ui.draggable.data('amount');

			if (tInv === "invLeft"){
				if (origin === "invLeft"){
					$.post("http://shops/populateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}))

					$(".amount").val("");
				} else if (origin === "invRight"){
					$.post("http://shops/functionShops",JSON.stringify({
						shop: selectShop,
						item: itemData.key,
						slot: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			} else if (tInv === "invRight"){
				if (origin === "invLeft" && selectType === "Sell"){
					$.post("http://shops/functionShops",JSON.stringify({
						shop: selectShop,
						item: itemData.key,
						slot: itemData.slot,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			}
		}
	});

	$('.populated').droppable({
		hoverClass: 'hoverControl',
		drop: function(event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;
			
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let amount = $(".amount").val();
			if (shiftPressed) amount = ui.draggable.data('amount');


			if (tInv === "invLeft" ){
				if (origin === "invLeft"){
					$.post("http://shops/updateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				} else if (origin === "invRight"){
					$.post("http://shops/functionShops",JSON.stringify({
						shop: selectShop,
						item: itemData.key,
						slot: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			} else if (tInv === "invRight"){
				if (origin === "invLeft" && selectType === "Sell"){
					$.post("http://shops/functionShops",JSON.stringify({
						shop: selectShop,
						item: itemData.key,
						slot: itemData.slot,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			}
		}
	});

	$(".populated").tooltip({
		create: function(event,ui){
			var serial = $(this).attr("data-serial");
			var economy = $(this).attr("data-economy");
			var desc = $(this).attr("data-description");
			var price = $(this).attr("data-price");
			var name = $(this).attr("data-name-key");
			var weight = $(this).attr("data-peso");
			var type = $(this).attr("data-type");
			var max = $(this).attr("data-max");
			var myLeg = "center top-196";

			if (desc !== "undefined"){
				myLeg = "center top-219";
			}

			$(this).tooltip({
				content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${serial !== "undefined" ? "Serial: <r>"+serial+"</r>":"Tipo: <r>"+type+"</r>"} <s>|</s> Máximo: <r>${max !== "undefined" ? max:"S/L"}</r><br>Peso: <r>${Number(weight).toFixed(2)}</r></r> <s>|</s> Economia: <r>${economy !== "S/V" ? "$"+formatarNumero(economy):economy}</r></legenda>`,
				position: { my: myLeg, at: "center" },
				show: { duration: 10 },
				hide: { duration: 10 }
			})
		}
	});
}
/* --------------------------------------------------- */
const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}
/* --------------------------------------------------- */
const colorPicker = (percent) => {
	var colorPercent = "#2e6e4c";

	if (percent >= 100)
		colorPercent = "rgba(255,255,255,0)";

	if (percent >= 51 && percent <= 75)
		colorPercent = "#fcc458";

	if (percent >= 26 && percent <= 50)
		colorPercent = "#fc8a58";

	if (percent <= 25)
		colorPercent = "#fc5858";

	return colorPercent;
}

const requestShop = () => {
	$.post("http://shops/requestShop",JSON.stringify({ shop: selectShop }),(data) => {
		$("#weightTextLeft").html(`${(data["invPeso"]).toFixed(2)}   /   ${(data["invMaxpeso"]).toFixed(2)}`);

		$("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["invPeso"] / data["invMaxpeso"] * 100}%"></div>`);

		$(".invLeft").html("");
		$(".invRight").html("");

		for (let x = 1; x <= data["invMaxpeso"]; x++){
			const slot = x.toString();

			if (data.inventoryUser[slot] !== undefined){
				const v = data["inventoryUser"][slot];
				const maxDurability = 86400 * v["days"];
				const newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" style="background-image: url('nui://inventory/web-side/images/${v["index"]}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-peso="${v["peso"]}" data-amount="${v["amount"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}">
					<div class="top">
						<div class="itemWeight">${(v.peso * v.amount).toFixed(2)}</div>
						<div class="itemAmount">${formatarNumero(v.amount)}x</div>
					</div>

					<div class="durability" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
					<div class="nameItem">${v["name"]}</div>
				</div>`;

				$(".invLeft").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invLeft").append(item);
			}
		}

		const nameList2 = data.inventoryShop.sort((a,b) => (a.name > b.name) ? 1: -1);

		for (let x = 1; x <= data["shopSlots"]; x++){
			const slot = x.toString();

			if (nameList2[x-1] !== undefined){
				const v = nameList2[x - 1];

				const item = `<div class="item populated" title="" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" style="background-image: url('nui://inventory/web-side/images/${v.index}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-price="${v["price"]}" data-peso="${v["peso"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}">
					<div class="top">
						<div class="itemWeight">${(v["peso"]).toFixed(2)}</div>
						<div class="itemPrice">$${formatarNumero(v["price"])}</div>
					</div>

					<div class="durability"></div>
					<div class="nameItem">${v["name"]}</div>
				</div>`;

				$(".invRight").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invRight").append(item);
			}
		}
		updateDrag();
	});
}

function somenteNumeros(e){
	var charCode = e.charCode ? e.charCode : e.keyCode;
	if (charCode != 8 && charCode != 9){
		var max = 9;
		var num = $(".amount").val();

		if ((charCode < 48 || charCode > 57)||(num.length >= max)){
			return false;
		}
	}
}