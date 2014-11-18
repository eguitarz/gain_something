bindCancelButton = (selector)->
	$(selector).off('click').on 'click', (e)->
		e.preventDefault()
		e.stopPropagation()
		window.location = $(@).data('dest')

bindDifficultyButton = (selector)->
	$(selector).off('click').on 'click', (e)->
		e.preventDefault()
		e.stopPropagation()
		$(@).toggleClass('selected').siblings().removeClass('selected')

		if $('.btn-difficulty.selected').length > 0
			$('#course-difficulty').val $('.btn-difficulty.selected').data('difficulty')
		else
			$('#course-difficulty').val('none')
		setEditStatus(false)

bindKeypress = (selector)->
	$(selector).keypress (e)->
		unless e.which == 0 # not a control character
			setEditStatus(false)


setEditStatus = (isSaved)->
	if isSaved
		$('body').removeClass('unsaved')
	else
		$('body').addClass('unsaved')

$(document).on 'page:change', ->
	return unless $('body#courses').length > 0
	console.log 'running courses.js - ' + (new Date)

	bindCancelButton('.btn-cancel')
	bindDifficultyButton('.btn-difficulty')
	bindKeypress('#course_name, #course_description')