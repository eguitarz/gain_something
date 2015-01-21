focus = (jqElem)->
  if jqElem.hasClass '_is_focus'
    jqElem.removeClass '_is_focus'
    return null
  else
    jqElem.addClass '_is_focus'
    jqElem.siblings().removeClass '_is_focus'
    id = jqElem.attr('id')
    return $("#display_#{id}")


$(document).on 'page:change', ->
  if $('body#discovery').length > 0
    resourceMapWidth = $('#resourceMap').width()
    resourceMapGridWidth = resourceMapWidth / 6 - 8
    resourceMapGridWidth = 80 if resourceMapGridWidth < 80

    markdownElems = $('[data-mime="text"] .resourceDisplayer_item_description_markdown')
    for elem in markdownElems
      $(elem).siblings('.resourceDisplayer_item_description').html marked(decodeURIComponent($(elem).val()))

    $('._is_preload').removeClass('_is_preload')

    focusedItem = null
    $('.resourceMap_grid').css('width', resourceMapGridWidth).css('height', resourceMapGridWidth)
      .hover ->
        id = $(@).attr('id')
        $("#display_#{id}").addClass('_is_show')
        focusedItem.removeClass('_is_show') if focusedItem && !$(@).is($('._is_focus').first())
      , ->
        id = $(@).attr('id')
        $("#display_#{id}").removeClass('_is_show')
        focusedItem.addClass('_is_show') if focusedItem
      .click ->
        # $(@).toggleClass '_is_focus'
        focusedItem = focus($(@))