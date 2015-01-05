createMarkdownEditor = (elementId)->
	codemirror = CodeMirror.fromTextArea(document.getElementById(elementId), {
		mode: 'markdown'
		styleActiveLine: 'enabled' 
		placeholder: 'Write something...'
		lineWrapping: true
		tabSize: 2
	})

initEditorButtons = (editor)->
	getSelectedInsertionString = (type)->
		selection = editor.getSelection()
		switch type 
			when 'h1' then  "# #{selection}"
			when 'h2' then  "## #{selection}"
			when 'h3' then  "### #{selection}"
			when 'italic' then "* #{selection} *"
			when 'bold' then "** #{selection} **"
			when 'link' then "[#{selection}](YOUR_URL)"
			when 'image' then "![IMAGE_DESCRIPTION](#{selection})"

	getNotSelectedInsertionString = (type)->
		switch type 
			when 'h1' then  "# H1 title here"
			when 'h2' then  "## H2 title here"
			when 'h3' then  "### H3 title here"
			when 'italic' then "**"
			when 'bold' then "*"
			when 'link' then "[TEXT_TO_LINK](THE_URL)"
			when 'image' then "![IMAGE_DESCRIPTION](IMAGE_URL)"

	getCursorPosition = (type)->
		'end'


	insertMarkdown = (type)->
		selection = editor.getSelection()
		insertionNotSelected = getNotSelectedInsertionString(type)
		insertionSelected = getSelectedInsertionString(type)
		cursorPosition = getCursorPosition(type)
		taggedSelection = if selection then insertionSelected else insertionNotSelected
		editor.replaceSelection( taggedSelection, cursorPosition )
		editor.focus()

	$('.btn-icon').on 'click', (e)->
		e.preventDefault()
		e.stopPropagation()

	$('#h1-btn').on 'click', ->
		insertMarkdown('h1')

	$('#h2-btn').on 'click', ->
		insertMarkdown('h2')

	$('#h3-btn').on 'click', ->
		insertMarkdown('h3')

	$('#italic-btn').on 'click', ->
		insertMarkdown('italic')

	$('#bold-btn').on 'click', ->
		insertMarkdown('bold')

	$('#link-btn').on 'click', ->
		insertMarkdown('link')

	$('#image-btn').on 'click', ->
		insertMarkdown('image')

	$('#preview-btn').on 'click', ->
		$('body').toggleClass 'preview-mode'

		$('#markdown-preview').html marked(editor.getValue())
		

bindCancelButton = (selector)->
	$(selector).off('click').on 'click', (e)->
		e.preventDefault()
		e.stopPropagation()
		window.location = $(@).data('dest')

bindOnPaste = (selector)->
	$(selector).off('paste').on 'paste', (e)->
		input = @
		setTimeout ->
			url = $(input).val()
			$.getJSON "http://localhost:3000/preview.json?url=#{url}", (response)->
				$('.preview').html response.html
				$('#link-title').val response.title
				$('#link-description').val response.description

		, 100

$(document).on 'page:change', ->
	return unless $('body#resources').length > 0
	console.log 'running resources.js - ' + (new Date)

	editor = createMarkdownEditor('resource-description') if $('#resource-description').length > 0
	window.editor = editor
	initEditorButtons(editor)
	bindCancelButton('.btn-cancel')
	# This has CORS problem
	# bindOnPaste('#link-url')

	# bind title key events
	$('#resource_title').on 'keydown', (e)->
		if e.keyCode == 13 || e.keyCode == 9
			e.preventDefault()
			e.stopPropagation()
			editor.focus()

	# parse markdown
	$('.description').html marked(decodeURIComponent($('#desc-value').val()))
