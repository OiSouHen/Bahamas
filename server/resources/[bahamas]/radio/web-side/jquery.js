$(document).ready(function(){
    $('#freq').focus(function() {
        $(this).val('');
    });
  
    window.addEventListener("message",function(event){
        switch (event.data.action){
            case "showMenu":
                $("#actionmenu").css("display","block");
                break;
        }
    });  

    document.onkeyup = function(data){
        const key = data.key;
        switch(key) {
            case 'Escape':
                $("#actionmenu").css("display","none");
                $.post("http://radio/radioClose");
                break;
            case 'Enter':
                $("#freq").blur();
                setFrequency();
                break;
        }
	}
});

$(document).on("click", ".ativar", debounce(function(){
	setFrequency();
}));

$(document).on("click", ".desativar", debounce(function(){
	$.post("http://radio/inativeFrequency");
}));

function debounce(func,immediate){
	var timeout
	return function () {
		var context = this, args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,500)
		if (callNow) func.apply(context,args)
	}
}

const setFrequency = debounce(() => {
    let freq = parseInt($('#freq').val());
	if (freq > 0){
		$.post("http://radio/activeFrequency",JSON.stringify({ freq }));
	}
});