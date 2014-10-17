$(document).ready ->
	$('#overlay').on 'click', ->
		$('body').toggleClass 'siteMenuOpened'