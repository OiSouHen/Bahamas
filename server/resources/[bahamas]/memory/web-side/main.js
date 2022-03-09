let Actives = [];
let CanClick = false;
let AmountOfSquares = 0;
let CorrectlySelectedSquares = 0;
let CONTAINER = document.querySelector(".memory-wrapper");

window.addEventListener("message",function(event){
	if (event["data"]["action"] === "start"){
		SetupMemoryGame();
	}

	if (event["data"]["action"] === "fail"){
		CanClick = false;
		$(".text").html("Hack falhou...");

		$(".memory-wrapper").fadeOut(250,() => {
			$(".help-text").fadeIn(250);
			setTimeout(() => {
				$.post("http://memory/fail")
				$(".memory-container").fadeOut(500);
			},2000);
		});
	}
});

function SetupMemoryGame(){
	Actives = [];
	CanClick = false;
	AmountOfSquares = 0;
	CorrectlySelectedSquares = 0;

	$(".memory-wrapper").html("");
	$(".memory-wrapper").css("display","none");
	$(".memory-container").fadeIn(500);

	[].forEach.call(document.querySelectorAll(".box-active"),function(element){
		element.classList.remove("box-active");
	});

	$(".text").html("Preparando o hack...")

	$(".help-text").fadeIn(100,() => {
		$(".memory-container").fadeIn(1000)
		setTimeout(() => {
			$(".text").html("Rompendo o sistema...")
			setTimeout(() => {
				$(".help-text").fadeOut(0)
				$(".memory-wrapper").fadeIn(500);

				for (let i = 1; i < 7; i++) {
					let row = document.createElement("div");
					row.classList.add("row");

					for (let k = 1; k < 7; k++){
						let square = document.createElement("div");
						square.classList.add("box");
						let id = `${i}-${k}`;
						square.setAttribute("id",id);

						if (RandomNum(1,5) == 3 && (AmountOfSquares < 7)){
							AmountOfSquares++;
							square.classList.add("box-active");
							Actives[id] = true;
						}

						square.addEventListener("click",ClickSquare)
						row.appendChild(square);
					}

					CONTAINER.appendChild(row);
				}

				setTimeout(() => {
					CONTAINER.style.opacity = "0";

					setTimeout(() => {
						[].forEach.call(document.querySelectorAll(".box-active"),function(element){
							element.classList.remove("box-active");
						});

						setTimeout(() => {
							CONTAINER.style.opacity = "100";
							CanClick = true;
						},1000);
					},1000);
				},5000);

				$(".memory-wrapper").css("display","inline-block");
			},1000);
		},1000);
	});
}

function RandomNum(min,max){
	return Math.floor(Math.random() * (max - min) + min);
} 

function ClickSquare(e){
	if (!CanClick) return;

	let ClickedId = e.target.id;

	let sound = new Audio("sounds/click.mp3");
	sound.volume = 0.8;
	sound.play();

	if (Actives[ClickedId]) {
		CanClick = false;
		CorrectlySelectedSquares++;

		Actives[ClickedId] = false;
		this.style.background = "white";

		if (CorrectlySelectedSquares >= AmountOfSquares) {
			CanClick = false;
			$(".text").html("Hack concluído...");

			$(".memory-wrapper").fadeOut(250,() => {
				$(".help-text").fadeIn(250);
				setTimeout(() => {
					$.post("http://memory/success")
					$(".memory-container").fadeOut(500);
				},2000);
			});
		} else {
			CanClick = true;
		}
	} else {
		CanClick = false;
		$(".text").html("Hack falhou...");

		$(".memory-wrapper").fadeOut(250,() => {
			$(".help-text").fadeIn(250);
			setTimeout(() => {
				$.post("http://memory/fail")
				$(".memory-container").fadeOut(500);
			},2000);
		});
	}
}