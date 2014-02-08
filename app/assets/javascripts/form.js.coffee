$ ->
	if typeof structure_to_render is 'undefined'
		structure_form = new StructureForm
	else
		structure_form = new StructureForm(structure_to_render)
		if not(typeof form is 'undefined')
			structure_form.form = form

		structure_form.renderPreview()

class StructureForm
	@structure_form_tag
	@structure_elements
	@form

	constructor: (elements=[]) ->
		@structure_elements = []
		for e in elements
			@structure_elements.push new StructureElement(e)

		# form to add input fields
		@structure_form_tag = $('#add_structure')
		@editable = $('#form_preview').hasClass('editable')

		# add new input field to structure
		@structure_form_tag.find('.submit').on "click", (e) =>
			e.preventDefault()
			@addToStructure()

		# add option to radiobuttons
		@structure_form_tag.find('#current_structure_form').on 'click', '.add_option', (e) =>
			e.preventDefault()
			@add_option()

		# load input type specific form
		@structure_form_tag.find('select').on( "change", =>
			@loadStructureForm @structure_form_tag.find(':selected').val()
		).trigger('change')

		# edit caption
		if @editable
			$('#form_preview').on 'click', 'label', (e) =>
				e.preventDefault()
				label = $(e.target)
				i = label.attr('for')

				label_input = $('<input type="text">').val(label.text())
				label.hide().before(label_input)
				label_input.focus()
				label_input.on 'blur', (e) =>
					@structure_elements[i].change_caption $(e.target).val()
					if not (@structure_elements[i].data['class'] is "immutable_element")
						@structure_elements[i].change_name $(e.target).val()
					@renderPreview()

		# delete element from structure
		$('#form_preview').on 'click', '.delete_element', (e) =>
			e.preventDefault()
			@structure_elements.splice [parseInt($(e.target).attr('id').replace('delete_', ''))], 1
			@renderPreview()

	update_structure_val: ->
		elements = []
		for se in @structure_elements
			elements.push(se.data)
		$('#form_structure').val(JSON.stringify(elements))

	add_option: ->
		# console.log('add option')
		options_len = @structure_form_tag.find('#current_structure_form .options_set').length
		# console.log(options_len)
		new_option = $('<div class="options_set option'+options_len+'" data-option="'+options_len+'">
		      <label for="option'+options_len+'">Option '+options_len+'</label>
		      <input class="disabled" type="text" name="option'+options_len+'">
		    </div>')
		new_option.on 'change', (e) =>
			options = {}
			@structure_form_tag.find('.options_set input').each ->
				options[$(@).attr('name')] = $(@).val()
			# console.log(options)
			# console.log @structure_form_tag.find('.options')
			@structure_form_tag.find('input[name="options"]').val(JSON.stringify(options))
			#@structure_form_tag.find('input[name="options"]').val()
		@structure_form_tag.find('#current_structure_form .add_option').before new_option

	loadStructureForm: (type) ->
		@structure_form_tag.find('#current_structure_form').empty().html($('#structure_forms .'+type).clone().html())

	addToStructure: ->
		# disable hidden fields
		@structure_form_tag.find('.disabled').each ->
			$(@).prop('disabled', true)

		# create new element
		data = @structure_form_tag.serializeArray()
		structure_element = new StructureElement()
		structure_element.from_form(data)
		console.log structure_element
		@structure_elements.push structure_element

		# render preview and load clean structure form
		@renderPreview()
		@loadStructureForm(@structure_form_tag.find(':selected').val())
		$('#add_structure #caption').val('')

	renderPreview: ->
		if @editable
			editable_form_elements = []
			index = 0
			for se in @structure_elements
				se.data['id'] = ""+index
				editable_form_elements.push se.data
				if not (se.data['class'] is "immutable_element")
					link = {type: "a", href: ""+index, html: "Delete", class: "delete_element", id: "delete_"+index}
					editable_form_elements.push link
				index++
			form = if @form then @form else {html:[]}
			form.html = editable_form_elements
		else
			form = if @form then @form else {html:[]}
			for se in @structure_elements
				if not(se.data["type"] is "checkbox") 
					se.data["required"] = true
				form.html.push se.data
		$('#form_preview').empty().dform(form)
		@update_structure_val()

class StructureElement
	constructor:(@data) ->

	from_form:(data) =>
		obj = {}
		$.map data, (n, i) ->
			if n['name'] is 'options'
				obj[n['name']] = $.parseJSON(n['value'])
			else
				obj[n['name']] = n['value']
		@data = obj
		@change_name obj['caption']

	change_caption: (caption) =>
		@data['caption'] = caption

	change_name: (name) =>
		@data['name'] = name.toLowerCase().replace(/[^a-z0-9\s]/gi, '').replace(/[-\s]/g, '_')

