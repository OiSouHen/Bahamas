cReative = {}

var selectedTab = ".characterTab"
var lastCategory = "character"
var selectedCam = null;

var clothingCategorys = [];

const skinData = {
	pants: { defaultItem: 0, defaultTexture: 0 },
	arms: { defaultItem: 0, defaultTexture: 0 },
	tshirt: { defaultItem: 1, defaultTexture: 0 },
	torso: { defaultItem: 0, defaultTexture: 0 },
	vest: { defaultItem: 0, defaultTexture: 0 },
	shoes: { defaultItem: 1, defaultTexture: 0 },
	mask: { defaultItem: 0, defaultTexture: 0 },
	hat: { defaultItem: -1, defaultTexture: 0 },
	glass: { defaultItem: 0, defaultTexture: 0 },
	ear: { defaultItem: -1, defaultTexture: 0 },
	watch: { defaultItem: -1, defaultTexture: 0 },
	bracelet: { defaultItem: -1, defaultTexture: 0 },
	accessory: { defaultItem: 0, defaultTexture: 0 },
	decals: { defaultItem: 0, defaultTexture: 0 }
}

$(document).on('click', '.clothing-menu-header-btn', function(e){
	var category = $(this).data('category');

	$(selectedTab).removeClass("selected");
	$(this).addClass("selected");
	$(".clothing-menu-"+lastCategory+"-container").css({"display": "none"});

	lastCategory = category;
	selectedTab = this;

	$(".clothing-menu-"+category+"-container").css({"display": "block"});
})

cReative.ResetItemTexture = function(obj, category) {
	var itemTexture = $(obj).parent().parent().find('[data-type="texture"]');
	var defaultTextureValue = skinData[category].defaultTexture;
	$(itemTexture).val(defaultTextureValue);

	$.post('http://skinshop/updateSkin', JSON.stringify({
		clothingType: category,
		articleNumber: defaultTextureValue,
		type: "texture",
	}));
}

$(document).on('click', '.clothing-menu-option-item-right', function(e){
	e.preventDefault();

	var clothingCategory = $(this).parent().parent().data('type');
	var buttonType = $(this).data('type');
	var inputElem = $(this).parent().find('input');
	var inputVal = $(inputElem).val();
	var newValue = parseFloat(inputVal) + 1;

	if (clothingCategory == "hair") {
		$(inputElem).val(newValue);
		$.post('http://skinshop/updateSkin', JSON.stringify({
			clothingType: clothingCategory,
			articleNumber: newValue,
			type: buttonType,
		}));
		if (buttonType == "item") {
			cReative.ResetItemTexture(this, clothingCategory);
		}
	} else {
		if (buttonType == "item") {
			var buttonMax = $(this).parent().find('[data-headertype="item-header"]').data('maxItem');
			if (clothingCategory == "accessory" && newValue == 13) {
				$(inputElem).val(14);
				$.post('http://skinshop/updateSkin', JSON.stringify({
					clothingType: clothingCategory,
					articleNumber: 14,
					type: buttonType,
				}));
			} else {
				if (newValue <= parseInt(buttonMax)) {
					$(inputElem).val(newValue);
					$.post('http://skinshop/updateSkin', JSON.stringify({
						clothingType: clothingCategory,
						articleNumber: newValue,
						type: buttonType,
					}));
				}
			}
			cReative.ResetItemTexture(this, clothingCategory);
		} else {
			var buttonMax = $(this).parent().find('[data-headertype="texture-header"]').data('maxTexture');
			if (newValue <= parseInt(buttonMax)) {
				$(inputElem).val(newValue);
				$.post('http://skinshop/updateSkin', JSON.stringify({
					clothingType: clothingCategory,
					articleNumber: newValue,
					type: buttonType,
				}));
			}
		}
	}
});

$(document).on('click', '.clothing-menu-option-item-left', function(e){
	e.preventDefault();

	var clothingCategory = $(this).parent().parent().data('type');
	var buttonType = $(this).data('type');
	var inputElem = $(this).parent().find('input');
	var inputVal = $(inputElem).val();
	var newValue = parseFloat(inputVal) - 1;

	if (buttonType == "item") {
		if (newValue >= skinData[clothingCategory].defaultItem) {
			if (clothingCategory == "accessory" && newValue == 13) {
				$(inputElem).val(12);
				$.post('http://skinshop/updateSkin', JSON.stringify({
					clothingType: clothingCategory,
					articleNumber: 12,
					type: buttonType,
				}));
			} else {
				$(inputElem).val(newValue);
				$.post('http://skinshop/updateSkin', JSON.stringify({
					clothingType: clothingCategory,
					articleNumber: newValue,
					type: buttonType,
				}));
			}
		}
		cReative.ResetItemTexture(this, clothingCategory);
	} else {
		if (newValue >= skinData[clothingCategory].defaultTexture) {
			if (clothingCategory == "accessory" && newValue == 13) {
				$(inputElem).val(12);
				$.post('http://skinshop/updateSkin', JSON.stringify({
					clothingType: clothingCategory,
					articleNumber: 12,
					type: buttonType,
				}));
			} else {
				$(inputElem).val(newValue);
				$.post('http://skinshop/updateSkin', JSON.stringify({
					clothingType: clothingCategory,
					articleNumber: newValue,
					type: buttonType,
				}));
			}
		}
	}
});

var changingCat = null;

function ChangeUp() {
	var clothingCategory = $(changingCat).parent().parent().data('type');
	var buttonType = $(changingCat).data('type');
	var inputVal = parseFloat($(changingCat).val());

	if (clothingCategory == "accessory" && inputVal + 1 == 13) {
		$(changingCat).val(14 - 1)
	}
}

function ChangeDown() {
	var clothingCategory = $(changingCat).parent().parent().data('type');
	var buttonType = $(changingCat).data('type');
	var inputVal = parseFloat($(changingCat).val());


	if (clothingCategory == "accessory" && inputVal - 1 == 13) {
		$(changingCat).val(12 + 1)
	}
}

$(document).on('change', '.item-number', function(){
	var clothingCategory = $(this).parent().parent().data('type');
	var buttonType = $(this).data('type');
	var inputVal = $(this).val();

	changingCat = this;

	if (clothingCategory == "accessory" && inputVal == 13) {
		$(this).val(12);
		return
	} else {
		$.post('http://skinshop/updateSkinOnInput', JSON.stringify({
			clothingType: clothingCategory,
			articleNumber: parseFloat(inputVal),
			type: buttonType,
		}));
	}
});

$(document).on('click', '.clothing-menu-header-camera-btn', function(e){
	e.preventDefault();

	var camValue = parseFloat($(this).data('value'));

	if (selectedCam == null) {
		$(this).addClass("selected-cam");
		$.post('http://skinshop/setupCam', JSON.stringify({
			value: camValue
		}));
		selectedCam = this;
	} else {
		if (selectedCam == this) {
			$(selectedCam).removeClass("selected-cam");
			$.post('http://skinshop/setupCam', JSON.stringify({
				value: 0
			}));

			selectedCam = null;
		} else {
			$(selectedCam).removeClass("selected-cam");
			$(this).addClass("selected-cam");
			$.post('http://skinshop/setupCam', JSON.stringify({
				value: camValue
			}));

			selectedCam = this;
		}
	}
});

$(document).on('keydown', function() {
	switch(event.keyCode) {
        case 68: // D
			$.post('http://skinshop/rotateRight');
			break;
        case 65: // A
			$.post('http://skinshop/rotateLeft');
			break;
        case 38: // UP
			ChangeUp();
			break;
        case 40: // DOWN
			ChangeDown();
			break;
    }
});

$(document).ready(function(){
	window.addEventListener('message', function(event) {
		switch(event.data.action) {
			case "open":
				cReative.Open(event.data);
			break;

			case "close":
				cReative.Close();
			break;

			case "updateMax":
				cReative.SetMaxValues(event.data.maxValues);
			break;
		}
	})
});

$(document).on('click', "#save-menu", function(e){
	e.preventDefault();
	cReative.Close();
	$.post('http://skinshop/saveClothing');
});

$(document).on('click', "#cancel-menu", function(e){
	e.preventDefault();
	cReative.Close();
	$.post('http://skinshop/resetOutfit');
});

cReative.SetCurrentValues = function(clothingValues) {
	$.each(clothingValues, function(i, item){
		var itemCats = $(".clothing-menu-container").find('[data-type="'+i+'"]');
		var input = $(itemCats).find('input[data-type="item"]');
		var texture = $(itemCats).find('input[data-type="texture"]');

		$(input).val(item.item);
		$(texture).val(item.texture);
	});
}

cReative.Open = function(data) {
	clothingCategorys = data.currentClothing;
	$(".clothing-menu-character-container").css("display","none");
	$(".clothing-menu-clothing-container").css("display","none");
	$(".clothing-menu-accessoires-container").css("display","none");

	$(".clothing-menu-container").css("display","block");

	cReative.SetMaxValues(data.maxValues);
	$(".clothing-menu-header").html("");
	cReative.SetCurrentValues(data.currentClothing);
	$.each(data.menus, function(i, menu){
		if (menu.selected) {
			$(".clothing-menu-header").append('<div class="clothing-menu-header-btn '+menu.menu+'Tab selected" data-category="'+menu.menu+'"><p>'+menu.label+'</p></div>')
			$(".clothing-menu-"+menu.menu+"-container").css({"display":"block"});
			selectedTab = "." + menu.menu + "Tab";
			lastCategory = menu.menu;

		} else {
			$(".clothing-menu-header").append('<div class="clothing-menu-header-btn '+menu.menu+'Tab" data-category="'+menu.menu+'"><p>'+menu.label+'</p></div>')
		}
	});

	var menuWidth = (100 / data.menus.length)

	$(".clothing-menu-header-btn").css("width", menuWidth + "%");
}

cReative.Close = function() {
	$.post("http://skinshop/close");
	$(".clothing-menu-container").css("display","none");

	$(selectedCam).removeClass('selected-cam');
	$(selectedTab).removeClass("selected");
	selectedCam = null;
	selectedTab = null;
	lastCategory = null;
}

cReative.SetMaxValues = function(maxValues) {
	$.each(maxValues, function(i, cat){
		if (cat.type == "character") {
			var containers = $(".clothing-menu-character-container").find('[data-type="'+i+'"]');
			var itemMax = $(containers).find('[data-headertype="item-header"]');
			var headerMax = $(containers).find('[data-headertype="texture-header"]');
			
			$(itemMax).data('maxItem', maxValues[containers.data('type')].item)
			$(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
			
			$(itemMax).html("<p><b>Modelos:</b> " + maxValues[containers.data('type')].item + "</p>")
			$(headerMax).html("<p><b>Texturas:</b> " + maxValues[containers.data('type')].texture + "</p>")
		} else if (cat.type == "hair") {
			var containers = $(".clothing-menu-clothing-container").find('[data-type="'+i+'"]');
			var itemMax = $(containers).find('[data-headertype="item-header"]');
			var headerMax = $(containers).find('[data-headertype="texture-header"]');
			
			$(itemMax).data('maxItem', maxValues[containers.data('type')].item)
			$(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
			
			$(itemMax).html("<p><b>Modelos:</b> " + maxValues[containers.data('type')].item + "</p>")
			$(headerMax).html("<p><b>Texturas:</b> " + maxValues[containers.data('type')].texture + "</p>")
		} else if (cat.type == "accessoires") {
			var containers = $(".clothing-menu-accessoires-container").find('[data-type="'+i+'"]');
			var itemMax = $(containers).find('[data-headertype="item-header"]');
			var headerMax = $(containers).find('[data-headertype="texture-header"]');
			
			$(itemMax).data('maxItem', maxValues[containers.data('type')].item)
			$(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
			
			$(itemMax).html("<p><b>Modelos:</b> " + maxValues[containers.data('type')].item + "</p>")
			$(headerMax).html("<p><b>Texturas:</b> " + maxValues[containers.data('type')].texture + "</p>")
		}
	})
}

$(document).on('click', '.change-camera-button', function(e){
	e.preventDefault();

	var rotationType = $(this).data('rotation');

	$.post('http://skinshop/rotateCam', JSON.stringify({
		type: rotationType
	}))
});