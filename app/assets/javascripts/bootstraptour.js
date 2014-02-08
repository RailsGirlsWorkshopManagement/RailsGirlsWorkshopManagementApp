var currentTour;
$(function() {
	currentTour = new MainTour();
	currentTour.init();

	if(!currentTour.tour.ended() && currentTour.tour.getCurrentStep()) {
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
		currentTour.start();
	});
});

function MainTour() {
	var _this = this;

	// Instance the tour
	_this.tour = new Tour({
		name: 'main',
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

	// Add your steps. Not too many, you don't really want to get your users sleepy
	_this.tour.addSteps(_this.getSteps());
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

MainTour.prototype.start = function() {
	var _this = this;

	_this.init();
	_this.tour.start();

	if(_this.tour.ended) {
		_this.tour.restart();
	}
};

MainTour.prototype.setWorkshopID = function(id) {
	localStorage.setItem('workshop_id', id);
};

MainTour.prototype.getWorkshopID = function() {
	return localStorage.getItem('workshop_id');
};

MainTour.prototype.getSteps = function() {
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
			title: "Creating a new workshop",
			content: "Let's start with creating a new workshop by clicking on the link 'New Workshop'",
			reflex: true,
			backdrop: true
		},
		{
			path: "/workshops/new",
			element: "form#new_workshop",
			placement: "top",
			title: "Configure you workshop",
			content: "Here you can just fill in the workshop information and continue by clicking on 'Create Workshop'",
			onShown: function() {
				$("form#new_workshop").on('submit', function() {
					_this.tour.goTo(4);
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
			content: "Have you filled all the input fields? Perfect! Let's go on.",
			onNext: function() {
				$("form#new_workshop").trigger('submit');
				//_this.tour.goTo(4);
			},
			reflex: true,
			backdrop: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			placement: "bottom",
			title: "Workshop Dashboard",
			content: "You created your first workshop. On this page you can configure everything you need for the workshop.",
			onShown: function() {
				$('#step-4.popover.tour-main .btn-group .btn').eq(0).prop('disabled', true);
			},
			backdrop: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			element: "form.edit_workshop",
			placement: "right",
			title: "Workshop Details",
			content: "In this box you find all the workshop related data and you are able to update it.",
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
					_this.tour.goTo(7);
				});
			},
			onHide: function() {
				$("div.workshop_show_mail_box").off();
			},
			next: 8,
			content: "Want to change the e-mail confirmation your participants will get or want to send an e-mail to groups of your participants? Here you find everything you need.",
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
					_this.tour.goTo(7);
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
					_this.tour.goTo(10);
				});
			},
			onHide: function() {
				$("div.workshop_show_form_box #add_participant_form").off();
			},
			title: "Workshop Forms",
			content: "here you can easily add forms which participants or coaches can use to register for your workshop.",
			backdrop: true
		},
		{
			path: "/workshops/{{workshop_id}}/edit",
			element: "div.workshop_show_form_box #add_participant_form",
			placement: "bottom",
			title: "Add a participant form",
			content: "If you want to create a form to get required data from your workshop participants, click here",
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
			content: "Here you can see a preview of the form you are working on. These three fields are not removable, but you can rename them if neccessary.",
			backdrop: true
		},
		{
			path: "/forms/new?type=participant&workshop_id={{workshop_id}}",
			element: "form#add_structure",
			placement: "bottom",
			title: "Add Elements",
			content: "Use this box to add fields of the types you need in your form",
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
			content: "Click here to save the form and continue",
			reflex: true
		},
		{
			path: "/forms/{{form_id}}",
			placement: "bottom",
			title: "Your form",
			onShown: function() {
				$('#step-13.popover.tour-main .btn-group .btn').eq(0).prop('disabled', true);
			},
			content: "This is how your form will look like for users",
		},
		{
			path: "/forms/{{form_id}}",
			element: "#back_to_workshop",
			placement: "right",
			title: "Go Back",
			content: "Click here to go back to your workshop dashboard",
			backdrop: true,
			reflex: true
		},
	];
};

