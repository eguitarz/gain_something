$(document).on 'page:change', ->
	$('.menu-btn').on 'click', ->
		$('body').toggleClass 'siteMenuOpened'