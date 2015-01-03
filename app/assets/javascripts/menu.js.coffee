$(document).on 'page:change', ->
	$('.btn-menu').off('click').on 'click', ->
		$('body').toggleClass '_siteMenu_is_open'

  $('#overlay').off('click').on 'click', ->
    $('body').toggleClass '_siteMenu_is_open'