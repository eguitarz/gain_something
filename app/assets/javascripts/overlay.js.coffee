$(document).on 'page:change', ->
	$('#overlay').off('click').on 'click', ->
		$('body').toggleClass 'siteMenuOpened'