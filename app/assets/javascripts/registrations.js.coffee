# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	$('#list_options form select, #list_registrations form input[type="checkbox"]').on 'change', ->
		$(this).closest('form').submit()

	$('#list_registrations form input.comment').on 'blur', ->
		$(this).closest('form').submit()


