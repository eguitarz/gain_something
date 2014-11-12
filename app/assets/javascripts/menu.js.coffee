$(document).on 'page:change', ->
	$('.menu-btn').off('click').on 'click', ->
		$('body').toggleClass 'siteMenuOpened'