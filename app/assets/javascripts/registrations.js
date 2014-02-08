$(function(){
	bindButtons();
	minimize_maximize(true, $('#list_registrations thead td'), $('#list_registrations tbody td'));
});

function bindButtons() {
	$('#maximize_all').click(function(e) {
		e.preventDefault();
		minimize_maximize(false, $('#list_registrations thead td'), $('#list_registrations tbody td'));
	});
	$('#minimize_all').click(function(e) {
		e.preventDefault();
		minimize_maximize(true, $('#list_registrations thead td'), $('#list_registrations tbody td'));
	});

	$('#list_registrations thead td').click(function(e) {
		var _this = this;
		console.log(e.target);
		console.log(this);

		e.preventDefault();
		var answers = [];
		answers = $(answers);
		$('#list_registrations tbody td').each(function(){
			if($(this).data("id") == $(_this).data("id")){
				answers.push($(this));
			}
		});
		//console.log(answers);
		if ($(this).attr("class") == "minimized") {
			minimize_maximize(false, $(this), answers);
		}
		else{
			minimize_maximize(true, $(this), answers);
		}
	});
}




function minimize_maximize(minimize, captions, answers){
	captions.each(function(){
		$(this).removeClass("minimized maximized");
		if($(this).data("id") > 2){
			if (minimize) {
				$(this).addClass("minimized");
			}
			else{
				$(this).addClass("maximized");
			}
		}
	});
	answers.each(function(){
		$(this).removeClass("minimizedAnswer maximizedAnswer");
		if($(this).data("id") > 2){
			if (minimize) {
				$(this).addClass("minimizedAnswer");
			}
			else{
				$(this).addClass("maximizedAnswer");
			}
		}
	});
}