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

refreshVideo = (videoId)->
	youtubeVideoInfoUrl = 'http://gdata.youtube.com/feeds/api/videos/'+videoId+'?v=2&alt=jsonc'
	$.ajax(youtubeVideoInfoUrl)
		.done (response)->
			console.log 'Recieved data from youtube'
			$('#video-title').val response.data.title
			$('#third-party-id').val videoId
		.error (reponse)->
			console.log 'Unable to recieve data from youtube'
			console.log response

createYoutubePlayer = (selector, videoId)->
	return unless $(selector).length > 0
	
	tag = document.getElementById('videoscript')
	playerId = $(selector).attr('id')
	
	if tag
		# remove youtube vars
		window.YT = null
		window.YTConfig = null

		tag.remove() 
		newPlayer = document.createElement('div')
		$(selector).before(newPlayer)
		$(selector).remove()
		$(newPlayer).attr('id', playerId)

	tag = document.createElement('script')
	tag.id = 'videoscript'
	tag.src = "https://www.youtube.com/player_api"
	firstScriptTag = document.getElementsByTagName('script')[0]
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)

	window.onYouTubePlayerAPIReady = ->
		player = new YT.Player playerId, {
			height: '390',
			width: '640',
			videoId: videoId
		}

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

	videoId = $('#ytplayer').data('video-id')
	createYoutubePlayer('#ytplayer', videoId) if videoId