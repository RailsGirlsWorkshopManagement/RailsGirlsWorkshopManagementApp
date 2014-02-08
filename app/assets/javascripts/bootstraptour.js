var currentTour;
$(function() {
	currentTour = new MainTour();

	if((!currentTour.tour.ended() && currentTour.tour.getCurrentStep()) || false) {
		var currentPath = document.location.pathname;
		var path_splitted = currentPath.split('/');
		if(path_splitted.length > 2) {
			if(path_splitted[1] === "forms" && path_splitted[2] !== "" && typeof path_splitted[2] !== "undefined" && path_splitted[2] !== "new") {
				localStorage.setItem('form_id', path_splitted[2]);
			}
		}
		var workshop_form = $('form.edit_workshop');
		if(workshop_form.length > 0) {
			var workshop_id = workshop_form.attr('id').replace('edit_workshop_', '');
			if(workshop_id !== '') {
				localStorage.setItem('workshop_id', workshop_id);
			}
		}
	}

	$('#start_tour_main').click(function(e) {
		e.preventDefault();
		currentTour.start("main");
	});
	$('#start_tour_add_form').click(function(e) {
		e.preventDefault();
		currentTour.start("add_form");
	});
	// $('#start_tour_use_form').click(function(e) {
	// 	e.preventDefault();
	// 	currentTour.start("use_form");
	// });
	// $('#start_tour_email').click(function(e) {
	// 	e.preventDefault();
	// 	currentTour.start("email");
	// });
});

function MainTour() {
	var _this = this;

	if("tourname" in localStorage) {
		var tourname = localStorage.getItem('tourname');
		_this.loadSteps(tourname);
		_this.init();
	} else {
		_this.loadSteps("main");
		_this.init();
	}
}

MainTour.prototype.redirect = function(path) {
	var _this = this;

	document.location.href = _this.getStepPath();
};

MainTour.prototype.getStepPath = function() {
	var _this = this;

	var path = _this.tour.getStep(_this.tour.getCurrentStep()).path;
	if(path.indexOf('{{workshop_id}}') > -1) {
		var workshop_id = localStorage.getItem('workshop_id');
		if(typeof workshop_id !== 'undefined' && workshop_id) {
			path = path.replace('{{workshop_id}}', workshop_id);
		} else {
			return false;
		}
	}

	if(path.indexOf('{{form_id}}') > -1) {
		var form_id = localStorage.getItem('form_id');
		if(typeof form_id !== 'undefined' && form_id) {
			path = path.replace('{{form_id}}', form_id);
			return path;
		} else {
			return false;
		}
	}

	return path;
};

MainTour.prototype.init = function() {
	var _this = this;

	// Initialize the tour
	_this.tour.init();
};

MainTour.prototype.loadSteps = function(tourname) {
	var _this = this;

	// Instance the tour
	_this.tour = new Tour({
		name: tourname,
		debug: true,
		orphan: true,
		redirect: function(path) {
			_this.redirect(path);
		},
		onEnd: function() {
			if('workshop_id' in localStorage) {
				localStorage.removeItem('workshop_id');
			}

			if('form_id' in localStorage) {
				localStorage.removeItem('form_id');
			}
		}
	});

	switch(tourname) {
		case "main":
			_this.tour.addSteps(_this.getMainSteps());
			_this.tour.addSteps(_this.getAddFormSteps());
			// _this.tour.addSteps(_this.getSteps());
			break;
		case "add_form":
			_this.tour.addSteps(_this.getAddFormSteps());
			break;
		// case "use_form":
		// 	_this.tour.addSteps(_this.getUseFormSteps());
		// 	break;
		// case "email":
		// 	_this.tour.addSteps(_this.getEmailSteps());
		// 	break;
	}
};

MainTour.prototype.start = function(tourname) {
	var _this = this;

	var currentPath = document.location.pathname;
	var path_splitted = currentPath.split('/');
	if(path_splitted.length > 2) {
		if(path_splitted[1] === "forms" && path_splitted[2] !== "" && typeof path_splitted[2] !== "undefined" && path_splitted[2] !== "new") {
			localStorage.setItem('form_id', path_splitted[2]);
		}
	}
	var workshop_form = $('form.edit_workshop');
	if(workshop_form.length > 0) {
		var workshop_id = workshop_form.attr('id').replace('edit_workshop_', '');
		if(workshop_id !== '') {
			localStorage.setItem('workshop_id', workshop_id);
		}
	}


	localStorage.setItem('tourname', tourname);
	_this.loadSteps(tourname);

	_this.init();
	_this.tour.start();

	if(_this.tour.ended) {
		_this.tour.restart();
	}
};

// MainTour.prototype.getEmailSteps = function() {
// 	var _this = this;
// 	return [
// 		{
// 			path: "/workshops/{{workshop_id}}/edit",
// 			element: "div.workshop_show_mail_box",
// 			placement: "right",
// 			title: "E-Mail configuration",
// 			content: "",
// 			backdrop: true
// 		}
// 	];
// };

// MainTour.prototype.getUseFormSteps = function() {
// 	var _this = this;
// 	return [
// 		{
// 			path: "/workshops",
// 			title: "Welcome to the Rails Girls Workshop Manamement App",
// 			content: "Learn about the functionality of this app in just a few steps!",
// 			backdrop: true
// 		}
// 	];
// };

MainTour.prototype.getMainSteps = function() {
	var _this = this;
	return [
		{
			path: "/workshops",
			title: "Welcome to the Rails Girls Workshop Manamement App",
			content: "Learn about the functionality of this app in just a few steps!",
			backdrop: true
		},
		{
			path: "/workshops",
			element: "#new_workshop_link",
			placement: "right",
			title: "Create a new workshop",
			content: "Let's start with creating a new workshop by clicking on the link 'New Workshop'",
			reflex: true,
			backdrop: true
		},
		{
			path: "/workshops/new",
			element: "form#new_workshop",
			placement: "top",
			title: "Specify the details of your Workshop",
			content: "Please fill out the form and click 'Create Workshop' to submit the data",
			onShown: function() {
				$("form#new_workshop").on('submit', function() {
					if($('#workshop_name').val() !== '' &&
						$('#workshop_description').val() !== '' &&
							$('#workshop_venue').val() !== '') {
						_this.tour.goTo(_this.tour.getCurrentStep()+2);
					}
				});
			},
			onHide: function() {
				$("form#new_workshop").off();
			},
			backdrop: true
		},
		{
			path: "/workshops/new",
			element: "form#new_workshop input[type='submit']",
			placement: "bottom",
			title: "Ready to continue?",
			content: "Have you entered all the requiered information? Perfect! Let's go on.",
			onNext: function() {
				if($('#workshop_name').val() === '' ||
						$('#workshop_description').val() === '' ||
							$('#workshop_venue').val() === '') {
					setTimeout(function() {
						_this.tour.goTo(_this.tour.getCurrentStep()-1);
					}, 10);
				} else {
					$("form#new_workshop").submit();
				}
			},
			reflex: true,
			backdrop: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			placement: "bottom",
			title: "Workshop Dashboard",
			content: "You created your first workshop. On this page you can manage everything regarding your workshop.",
			onShown: function() {
				$('#step-'+_this.tour.getCurrentStep()+'.popover .btn-group .btn').eq(0).prop('disabled', true);
			},
			backdrop: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			element: "form.edit_workshop",
			placement: "right",
			title: "Workshop Details",
			content: "This box gives you an overview of your workshop details. You can always update the fields by clicking 'Update Workshop'.",
			backdrop: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			element: "div.workshop_show_mail_box",
			placement: "right",
			title: "Workshop E-Mail Configuration",
			onShown: function() {
				$("div.workshop_show_mail_box").on('click', function(e) {
					e.preventDefault();
					_this.tour.goTo(_this.tour.getCurrentStep()+1);
				});
			},
			onHide: function() {
				$("div.workshop_show_mail_box").off();
			},
			next: 8,
			content: "Everyone who registers through your site will receive an e-mail confirmation. Don't worry, you are on copy. Change the template or send E-Mails to your participants and coaches.",
			backdrop: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			element: "div.workshop_show_mail_box",
			placement: "right",
			title: "Want to end the tour?",
			onShown: function() {
				$("div.workshop_show_mail_box").on('click', function(e) {
					e.preventDefault();
					_this.tour.goTo(_this.tour.getCurrentStep());
				});
			},
			onHide: function() {
				$("div.workshop_show_mail_box").off();
			},
			content: "Please end the tour if you want to play around now.",
			backdrop: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			element: "div.workshop_show_form_box",
			prev: 6,
			placement: "left",
			onShown: function() {
				$("div.workshop_show_form_box #add_participant_form").on('click', function() {
					_this.tour.goTo(_this.tour.getCurrentStep()+1);
				});
			},
			onHide: function() {
				$("div.workshop_show_form_box #add_participant_form").off();
			},
			title: "Workshop Forms",
			content: "Create a individual registration form for coaches or participants. To save some time you can reuse and modify existing forms.",
			backdrop: true
		}
	];
};


MainTour.prototype.getAddFormSteps = function() {
	var _this = this;
	return [
		{
			path: "/workshops/{{workshop_id}}/edit",
			element: "div.workshop_show_form_box #add_participant_form",
			placement: "bottom",
			title: "Add a participant form",
			content: "To create a participant form click here. Every question is required by default.",
			onNext: function() {
				$('div.workshop_show_form_box #add_participant_form').click();
			},
			backdrop: true,
			reflex: true
		},
		{
			path: "/forms/new?type=participant&workshop_id={{workshop_id}}",
			element: "form#form_preview",
			placement: "top",
			title: "Preview of the form you are creating",
			content: "These three fields are not removable, but you can rename them if neccessary.",
			backdrop: true
		},
		{
			path: "/forms/new?type=participant&workshop_id={{workshop_id}}",
			element: "form#add_structure",
			placement: "bottom",
			title: "Add Elements to your form",
			content: "Choose an input field type (text, checkbox, radiobutton, texarea) and enter a question or caption.",
			backdrop: true
		},
		{
			path: "/forms/new?type=participant&workshop_id={{workshop_id}}",
			element: "form#new_form",
			placement: "bottom",
			title: "Are you done?",
			onNext: function() {
				$('form#new_form').submit();
			},
			content: "Click here to save the form and continue.",
			reflex: true
		},
		{
			path: "/forms/{{form_id}}",
			placement: "bottom",
			title: "Congratulations to your fist participant form",
			onShown: function() {
				$('#step-'+_this.tour.getCurrentStep()+'.popover .btn-group .btn').eq(0).prop('disabled', true);
			},
			content: "This is how your form will look like for users.",
		},
		{
			path: "/forms/{{form_id}}",
			element: "#back_to_workshop",
			placement: "right",
			title: "Back to Workshop",
			content: "Click here to go back to your workshop dashboard.",
			backdrop: true,
			reflex: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			element: "div.workshop_show_form_box",
			placement: "left",
			title: "Successfully added a new form",
			content: "Here you can get the link for your form or edit it",
			backdrop: true,
			reflex: true
		},
	];
};

