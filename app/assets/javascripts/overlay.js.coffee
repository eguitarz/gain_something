$(document).on 'page:change', ->
	$('#overlay').on 'click', ->
		$('body').toggleClass 'siteMenuOpened'