$('.color').each(function(){
	var color = $(this).attr('data-color');
	$(this).css('background-color',color);
});

$('.arrow-right').on('click',function(e){
	e.preventDefault();
	var value = parseFloat($(this).prev().val()), newValue = parseFloat(value + 1), max = $(this).parent().prev().attr('data-legend');
	if(newValue <= max){
		$(this).prev().val(newValue);
		$(this).parent().prev().text(newValue+' / '+max);
	}
});

$('.arrow-left').on('click',function(e){
	e.preventDefault();
	var value = parseFloat($(this).next().val()), newValue = parseFloat(value - 1), max = $(this).parent().prev().attr('data-legend');
	if(newValue >= $(this).next().attr('min')){
		$(this).next().val(newValue);
		$(this).parent().prev().text(newValue+' / '+max);
	}
});

$('.arrowvetement-right').on('click',function(e){
	var li = $(this).parent().find('li.active'), active = li.next(), id = active.attr('data'), max = $(this).parent().find('li:last-of-type').attr('data');
	if($(this).prev().hasClass('active')){
		li.removeClass('active');
		$(this).parent().find('li:first-of-type').addClass('active');
		$(this).parent().parent().find('.label-value').text('0 / '+max)
	} else {
		li.removeClass('active');
		active.addClass('active');
		$(this).parent().parent().find('.label-value').text(id+' / '+max)
	}
});

$('.arrowvetement-left').on('click',function(e){
	var li = $(this).parent().find('li.active'), active = li.prev(), id = active.attr('data'), max = $(this).parent().find('li:last-of-type').attr('data');
	if($(this).next().hasClass('active')){
		li.removeClass('active');
		$(this).parent().find('li:last-of-type').addClass('active');
		$(this).parent().parent().find('.label-value').text(max+' / '+max)
	} else {
		li.removeClass('active');
		active.addClass('active');
		$(this).parent().parent().find('.label-value').text(id+' / '+max)
	}
});

$('.input .label-value').each(function(){
	var max = $(this).attr('data-legend'), val = $(this).next().find('input').val();
	$(this).parent().find('.label-value').text(val+' / '+max);
})

$('input[type=range]').change(function(){
	var value = parseFloat($(this).val()), max = $(this).parent().prev().attr('data-legend');
	$(this).parent().prev().text(value+' / '+max);
});

$('.tab a').on('click',function(e){
	e.preventDefault();
	var link = $(this).attr('data-link');
	$('.tab a').removeClass('active');
	$('.tab a.'+link).addClass('active').removeClass('disabled');

	$(this).addClass('disabled');
	$('.block.active').fadeOut(200,function(){
		$('.block').removeClass('active');
		$('.block.'+link).fadeIn(200,function(){
			$(this).addClass('active');
		});
	});
});

var x = 0;
var n = 100;
$(document).keydown(function(e){
	if (e.which == 40){
		x += n;
		$('#formBarbershop').animate({
			scrollTop: x
		},400);
	}

	if (e.which == 38){
		x -= n;
		$('#formBarbershop').animate({
			scrollTop: x
		},400);
	}
});