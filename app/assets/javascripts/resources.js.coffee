$(document).on 'ready page:change', ->
	codemirror = CodeMirror.fromTextArea(document.getElementById('resource-description'))