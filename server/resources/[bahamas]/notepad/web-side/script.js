let noteID = 0

$(document).ready(function(){
	window.addEventListener("message",function(event){
		let data = event["data"]

		$(".notepad textarea").val("")
		$(".notepad button").off("click")

		switch (data["action"]) {
			case "showNotepad":
				$(".notepad button").on("click",dropNote);
				$(".notepad button").html("Dropar");
				$("body").show();
			break;

			case "showNotepad2":
				$(".notepad button").on("click",editNote);
				$(".notepad textarea").val(data.text);
				$(".notepad button").html("Editar");
				noteID = data["id"]
				$("body").show();
			break;

			case "hideNotepad":
				$("body").hide();
			break;
		}
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://notepad/escape");
		};
	};
})

const dropNote = () => {
	$.post("http://notepad/dropNote",JSON.stringify({ text: $(".notepad textarea").val() }));
}

const editNote = () => {
	$.post("http://notepad/editNote",JSON.stringify({ text: $(".notepad textarea").val(), id: noteID }));
}