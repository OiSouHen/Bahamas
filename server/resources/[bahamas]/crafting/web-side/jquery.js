var selectCraft = "selectCraft";

$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch (event.data.action){
			case "showNUI":
				selectCraft = event.data.name;
				$(".inventory").css("display","flex");
				requestCrafting();
			break;

			case "hideNUI":
				$(".inventory").css("display","none");
				$(".ui-tooltip").hide();
			break;

			case "requestCrafting":
				requestCrafting();
			break;
		}
	});

	document.onkeyup = (data) => {
		if (data["key"] === "Escape"){
			$.post("http://crafting/invClose");
		}
	};
});

const updateDrag = () => {
	$(".populated").draggable({
		helper: "clone"
	});

	$(".empty").droppable({
		hoverClass: "hoverControl",
		drop: function (event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
			const target = $(this).data("slot");

			if (itemData.key === undefined || target === undefined) return;

			if (tInv === "invLeft"){
				if (origin === "invLeft"){
					itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
					const target = $(this).data("slot");

					if (itemData.key === undefined || target === undefined) return;
					let amount = $(".amount").val();
					if (shiftPressed) amount = ui.draggable.data("amount");

					$.post("http://crafting/populateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				} else if (origin === "invRight"){
					itemData = { key: ui.draggable.data("item-key") };
					const target = $(this).data("slot");

					if (itemData.key === undefined || target === undefined) return;

					$.post("http://crafting/functionCraft",JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: target,
						amount: parseInt($(".amount").val())
					}));

					$(".amount").val("");
				}
			} else if (tInv === "invRight"){
				if (origin === "invLeft"){
					itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

					if (itemData.key === undefined) return;
					let amount = $(".amount").val();
					if (shiftPressed) amount = ui.draggable.data("amount");

					$.post("http://crafting/functionDestroy",JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: itemData.slot,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				}
			}
		}
	});

	$(".populated").droppable({
		hoverClass: "hoverControl",
		drop: function (event,ui){
			if(ui.draggable.parent()[0] == undefined) return;

			const shiftPressed = event.shiftKey;
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].className;

			itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
			const target = $(this).data("slot");

			if (itemData.key === undefined || target === undefined) return;

			if (tInv === "invLeft"){
				if (origin === "invLeft"){
					itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };
					const target = $(this).data("slot");

					if (itemData.key === undefined || target === undefined) return;
					let amount = $(".amount").val();
					if (shiftPressed) amount = ui.draggable.data("amount");

					$.post("http://crafting/updateSlot",JSON.stringify({
						item: itemData.key,
						slot: itemData.slot,
						target: target,
						amount: parseInt(amount)
					}));

					$(".amount").val("");
				} else if (origin === "invRight"){
					itemData = { key: ui.draggable.data("item-key") };
					const target = $(this).data("slot");

					if (itemData.key === undefined || target === undefined || itemData.key !== $(this).data("item-key")) return;

					$.post("http://crafting/functionCraft",JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
						slot: target,
						amount: parseInt($(".amount").val())
					}));

					$(".amount").val("");
				}
			} else if (tInv === "invRight"){
				if (origin === "invLeft"){
					itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

					if (itemData.key === undefined) return;
					let amount = $(".amount").val();
					if (shiftPressed) amount = ui.draggable.data("amount");

					$.post("http://crafting/functionDestroy",JSON.stringify({
						craft: selectCraft,
						index: itemData.key,
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
			const desc = $(this).attr("data-description");
			const name = $(this).attr("data-name-key");
			const recipe = $(this).attr("data-list");
			var myLeg = "center top-176";

			if (desc !== "undefined"){
				myLeg = "center top-196";
			}

			$(this).tooltip({
				content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${recipe}</legenda>`,
				position: { my: myLeg, at: "center" },
				show: { duration: 10 },
				hide: { duration: 10 }
			})
		}
	});
};

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

const requestCrafting = () => {
	$.post("http://crafting/requestCrafting",JSON.stringify({ craft: selectCraft }),(data) => {
		$("#weightTextLeft").html(`${(data["invPeso"]).toFixed(2)}   /   ${(data["invMaxpeso"]).toFixed(2)}`);

		$("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["invPeso"] / data["invMaxpeso"] * 100}%"></div>`);

		$(".invLeft").html("");
		$(".invRight").html("");

		const nameList2 = data.inventoryCraft.sort((a,b) => a.name > b.name ? 1 : -1);

		for (let x = 1; x <= data["invMaxpeso"]; x++){
			const slot = x.toString();

			if (data.inventario[slot] !== undefined){
				const v = data.inventario[slot];
				const maxDurability = 86400 * v["days"];
				const newDurability = (maxDurability - v["durability"]) / maxDurability;
				var actualPercent = newDurability * 100;

				if (actualPercent <= 1)
					actualPercent = 1;

				const item = `<div class="item populated" style="background-image: url('nui://inventory/web-side/images/${v.index}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
					<div class="top">
						<div class="itemWeight">${(v.peso * v.amount).toFixed(2)}</div>
						<div class="itemAmount">${formatarNumero(v.amount)}x</div>
					</div>

					<div class="durability" style="width: ${parseInt(actualPercent)}%; background: ${colorPicker(actualPercent)};"></div>
					<div class="nameItem">${v.name}</div>
				</div>`;

				$(".invLeft").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invLeft").append(item);
			}
		}

		for (let x = 1; x <= 50; x++){
			const slot = x.toString();

			if (nameList2[x - 1] !== undefined){
				const v = nameList2[x - 1];
				let list = "";

				for (let i in v.list){
					list = `${list}${v.list[i].amount}x ${v.list[i].name}, `;
				}

				list = list.substring(0,list.length - 2);
				const item = `<div class="item populated" title="" style="background-image: url('nui://inventory/web-side/images/${v.index}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-list="${list}" data-slot="${slot}" data-description="${v["desc"]}">
					<div class="top">
						<div class="itemWeight">${v.peso.toFixed(2)}</div>
						<div class="itemAmount">${formatarNumero(v.amount)}x</div>
					</div>

					<div class="durability"></div>
					<div class="nameItem">${v.name}</div>
				</div>`;

				$(".invRight").append(item);
			} else {
				const item = `<div class="item empty" data-slot="${slot}"></div>`;

				$(".invRight").append(item);
			}
		}
		updateDrag();
	});
};

const formatarNumero = (n) => {
	var n = n.toString();
	var r = "";
	var x = 0;

	for (var i = n.length; i > 0; i--){
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? "." : "");
		x = x == 2 ? 0 : x + 1;
	}

	return r.split("").reverse().join("");
};