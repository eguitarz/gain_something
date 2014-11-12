bindCancelButton = (selector)->
	$(selector).off('click').on 'click', (e)->
		e.preventDefault()
		e.stopPropagation()
		window.location = $(@).data('dest')

$(document).on 'page:change', ->
	return unless $('body#courses').length > 0
	console.log 'running courses.js - ' + (new Date)

	bindCancelButton('.btn-cancel')