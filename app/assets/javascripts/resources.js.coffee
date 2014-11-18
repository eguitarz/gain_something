createMarkdownEditor = (elementId)->
	codemirror = CodeMirror.fromTextArea(document.getElementById(elementId), {
		mode: 'markdown'
		styleActiveLine: 'enabled' 
		placeholder: 'Write something...'
	})

bindCancelButton = (selector)->
	$(selector).off('click').on 'click', (e)->
		e.preventDefault()
		e.stopPropagation()
		window.location = $(@).data('dest')

bindOnPaste = (selector)->
	$(selector).off('paste').on 'paste', (e)->
		input = @
		setTimeout ->
			# url = encodeURIComponent($(input).val())
			url = $(input).val()
			$.getJSON "http://localhost:3000/preview.json?url=#{url}", (response)->
				$('.preview').html response.html
				$('#link-title').val response.title
				$('#link-description').val response.description
			# result = url.match('https?:\/\/www\.youtube\.com\/watch\\?v=(.*)')
			# if result && result[1]
			# 	videoId = result[1]
			# 	refreshVideo(videoId)

			# 	createYoutubePlayer('#ytplayer', videoId)	

		, 100

$(document).on 'page:change', ->
	return unless $('body#resources').length > 0
	console.log 'running resources.js - ' + (new Date)

	createMarkdownEditor('resource-description') if $('#resource-description').length > 0
	bindCancelButton('.btn-cancel')
	bindOnPaste('#link-url')