$(document).ready ->
	$('.menu-btn').on 'click', ->
		$('body').toggleClass 'siteMenuOpened'