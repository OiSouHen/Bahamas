$(document).ready(function(){
	var documentWidth = document.documentElement.clientWidth;
	var documentHeight = document.documentElement.clientHeight;
	var cursor = $('#cursorPointer');
	var cursorX = documentWidth/2;
	var cursorY = documentHeight/2;

	function triggerClick(x,y){
		var element = $(document.elementFromPoint(x,y));
		element.focus().click();
		return true;
	}

	window.addEventListener('message',function(event){
		$("#data-legend-hair").attr("data-legend",event.data.maxHair);
		$("#hair").attr("max",event.data.maxHair);

		document.getElementById("fathers").value = event.data.fathers;
		document.getElementById("mothers").value = event.data.mothers;
		document.getElementById("kinship").value = event.data.kinship;
		document.getElementById("eyecolor").value = event.data.eyecolor;
		document.getElementById("skincolor").value = event.data.skincolor;
		document.getElementById("acne").value = event.data.acne;
		document.getElementById("stains").value = event.data.stains;
		document.getElementById("freckles").value = event.data.freckles;
		document.getElementById("aging").value = event.data.aging;
		document.getElementById("hair").value = event.data.hair;
		document.getElementById("haircolor").value = event.data.haircolor;
		document.getElementById("haircolor2").value = event.data.haircolor2;
		document.getElementById("makeup").value = event.data.makeup;
		document.getElementById("makeupintensity").value = event.data.makeupintensity;
		document.getElementById("makeupcolor").value = event.data.makeupcolor;
		document.getElementById("lipstick").value = event.data.lipstick;
		document.getElementById("lipstickintensity").value = event.data.lipstickintensity;
		document.getElementById("lipstickcolor").value = event.data.lipstickcolor;
		document.getElementById("eyebrow").value = event.data.eyebrow;
		document.getElementById("eyebrowintensity").value = event.data.eyebrowintensity;
		document.getElementById("eyebrowcolor").value = event.data.eyebrowcolor;
		document.getElementById("beard").value = event.data.beard;
		document.getElementById("beardintentisy").value = event.data.beardintentisy;
		document.getElementById("beardcolor").value = event.data.beardcolor;
		document.getElementById("blush").value = event.data.blush;
		document.getElementById("blushintentisy").value = event.data.blushintentisy;
		document.getElementById("blushcolor").value = event.data.blushcolor;

		document.getElementById("face00").value = event.data.face00;
		document.getElementById("face01").value = event.data.face01;
		document.getElementById("face04").value = event.data.face04;
		document.getElementById("face06").value = event.data.face06;
		document.getElementById("face08").value = event.data.face08;
		document.getElementById("face09").value = event.data.face09;
		document.getElementById("face10").value = event.data.face10;
		document.getElementById("face12").value = event.data.face12;
		document.getElementById("face13").value = event.data.face13;
		document.getElementById("face14").value = event.data.face14;
		document.getElementById("face15").value = event.data.face15;
		document.getElementById("face16").value = event.data.face16;
		document.getElementById("face17").value = event.data.face17;
		document.getElementById("face19").value = event.data.face19;

		if(event.data.openBarbershop == true){
			$(".openBarbershop").css("display","block");

			$('.input .label-value').each(function(){
				var max = $(this).attr('data-legend'), val = $(this).next().find('input').val();
				$(this).parent().find('.label-value').text(val+' / '+max);
			});
		}

		if(event.data.openBarbershop == false){
			$(".openBarbershop").css("display","none");
		}

		if (event.data.type == "click") {
			triggerClick(cursorX-1,cursorY-1);
		}
	});

	$('input').change(function(){
		$.post('http://barbershop/updateSkin',JSON.stringify({
			value: false,
			fathers: $('.fathers').val(),
			mothers: $('.mothers').val(),
			kinship: $('.kinship').val(),
			eyecolor: $('.eyecolor').val(),
			skincolor: $('.skincolor').val(),
			acne: $('.acne').val(),
			stains: $('.stains').val(),
			freckles: $('.freckles').val(),
			aging: $('.aging').val(),
			hair: $('.hair').val(),
			haircolor: $('.haircolor').val(),
			haircolor2: $('.haircolor2').val(),
			makeup: $('.makeup').val(),
			makeupintensity: $('.makeupintensity').val(),
			makeupcolor: $('.makeupcolor').val(),
			lipstick: $('.lipstick').val(),
			lipstickintensity: $('.lipstickintensity').val(),
			lipstickcolor: $('.lipstickcolor').val(),
			eyebrow: $('.eyebrow').val(),
			eyebrowintensity: $('.eyebrowintensity').val(),
			eyebrowcolor: $('.eyebrowcolor').val(),
			beard: $('.beard').val(),
			beardintentisy: $('.beardintentisy').val(),
			beardcolor: $('.beardcolor').val(),
			blush: $('.blush').val(),
			blushintentisy: $('.blushintentisy').val(),
			blushcolor: $('.blushcolor').val(),
			face00: $('.face00').val(),
			face01: $('.face01').val(),
			face04: $('.face04').val(),
			face06: $('.face06').val(),
			face08: $('.face08').val(),
			face09: $('.face09').val(),
			face10: $('.face10').val(),
			face12: $('.face12').val(),
			face13: $('.face13').val(),
			face14: $('.face14').val(),
			face15: $('.face15').val(),
			face16: $('.face16').val(),
			face17: $('.face17').val(),
			face19: $('.face19').val()
		}));
	});

	$('.arrow').on('click',function(e){
		e.preventDefault();

		$.post('http://barbershop/updateSkin',JSON.stringify({
			value: false,
			fathers: $('.fathers').val(),
			mothers: $('.mothers').val(),
			kinship: $('.kinship').val(),
			eyecolor: $('.eyecolor').val(),
			skincolor: $('.skincolor').val(),
			acne: $('.acne').val(),
			stains: $('.stains').val(),
			freckles: $('.freckles').val(),
			aging: $('.aging').val(),
			hair: $('.hair').val(),
			haircolor: $('.haircolor').val(),
			haircolor2: $('.haircolor2').val(),
			makeup: $('.makeup').val(),
			makeupintensity: $('.makeupintensity').val(),
			makeupcolor: $('.makeupcolor').val(),
			lipstick: $('.lipstick').val(),
			lipstickintensity: $('.lipstickintensity').val(),
			lipstickcolor: $('.lipstickcolor').val(),
			eyebrow: $('.eyebrow').val(),
			eyebrowintensity: $('.eyebrowintensity').val(),
			eyebrowcolor: $('.eyebrowcolor').val(),
			beard: $('.beard').val(),
			beardintentisy: $('.beardintentisy').val(),
			beardcolor: $('.beardcolor').val(),
			blush: $('.blush').val(),
			blushintentisy: $('.blushintentisy').val(),
			blushcolor: $('.blushcolor').val(),
			face00: $('.face00').val(),
			face01: $('.face01').val(),
			face04: $('.face04').val(),
			face06: $('.face06').val(),
			face08: $('.face08').val(),
			face09: $('.face09').val(),
			face10: $('.face10').val(),
			face12: $('.face12').val(),
			face13: $('.face13').val(),
			face14: $('.face14').val(),
			face15: $('.face15').val(),
			face16: $('.face16').val(),
			face17: $('.face17').val(),
			face19: $('.face19').val()
		}));
	});

	$('.submit').on('click',function(e){
		e.preventDefault();

		$.post('http://barbershop/updateSkin',JSON.stringify({
			value: true,
			fathers: $('.fathers').val(),
			mothers: $('.mothers').val(),
			kinship: $('.kinship').val(),
			eyecolor: $('.eyecolor').val(),
			skincolor: $('.skincolor').val(),
			acne: $('.acne').val(),
			stains: $('.stains').val(),
			freckles: $('.freckles').val(),
			aging: $('.aging').val(),
			hair: $('.hair').val(),
			haircolor: $('.haircolor').val(),
			haircolor2: $('.haircolor2').val(),
			makeup: $('.makeup').val(),
			makeupintensity: $('.makeupintensity').val(),
			makeupcolor: $('.makeupcolor').val(),
			lipstick: $('.lipstick').val(),
			lipstickintensity: $('.lipstickintensity').val(),
			lipstickcolor: $('.lipstickcolor').val(),
			eyebrow: $('.eyebrow').val(),
			eyebrowintensity: $('.eyebrowintensity').val(),
			eyebrowcolor: $('.eyebrowcolor').val(),
			beard: $('.beard').val(),
			beardintentisy: $('.beardintentisy').val(),
			beardcolor: $('.beardcolor').val(),
			blush: $('.blush').val(),
			blushintentisy: $('.blushintentisy').val(),
			blushcolor: $('.blushcolor').val(),
			face00: $('.face00').val(),
			face01: $('.face01').val(),
			face04: $('.face04').val(),
			face06: $('.face06').val(),
			face08: $('.face08').val(),
			face09: $('.face09').val(),
			face10: $('.face10').val(),
			face12: $('.face12').val(),
			face13: $('.face13').val(),
			face14: $('.face14').val(),
			face15: $('.face15').val(),
			face16: $('.face16').val(),
			face17: $('.face17').val(),
			face19: $('.face19').val()
		}));
	});

	document.onkeydown = function(data){
		if(data.which == 65){
			$.post('http://barbershop/rotate',JSON.stringify("right"));
		}
		if(data.which == 68){
			$.post('http://barbershop/rotate',JSON.stringify("left"));
		}
	}
});