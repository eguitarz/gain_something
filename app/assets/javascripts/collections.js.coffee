bindCancelButton = (selector)->
  $(selector).off('click').on 'click', (e)->
    e.preventDefault()
    e.stopPropagation()
    window.location = $(@).data('dest')

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
  return unless $('body#collections').length > 0
  console.log 'running collection.js - ' + (new Date)

  bindCancelButton('.btn-cancel')
  bindKeypress('#collection_name, #collection_description')

  quitLightbox = ->
    $('iframe').first().attr('src', '')
    $('#lightbox .player .content').html ''
    $('body').removeClass '_is_lightbox_mode'
    $('#lightbox').removeClass()

    newUrl = window.location.href.replace(window.location.search, '')
    window.history.pushState(null, 'GS',  newUrl)

  $('#lightbox').click (e)->
    quitLightbox() if !$(e.target).hasClass('prevent-quit') && $(e.target).parents('.prevent-quit').length == 0

  $('#lightbox .btn-close').click ->
    quitLightbox()

  $('.editable input').on 'focus', ->
    $(@).parent('.editable').removeClass 'saved'

  $('.editable input').on 'keyup', (e)->
    keycode = e.keyCode
    if isPrintableKeycode(keycode)
      $(@).parent('.editable').addClass 'edited'

  $('.editable input').on 'blur', ->
    form = $(@).parent('.editable')
    if form.hasClass 'edited'
      form.removeClass 'edited'
      form.submit()

  $('.editable').on 'ajax:success', (e, data)->
    $(@).addClass('saved').find('input').blur()

  isLightboxMode = $('body').hasClass('_is_lightbox_mode')
  $(document).on 'keyup', (e)->
    $('.btn-next').click() if e.keyCode == 39 && isLightboxMode
    $('.btn-prev').click() if e.keyCode == 37 && isLightboxMode
    if e.keyCode == 27
      quitLightbox() # for lightbox
      $('body').removeClass '_is_confirmation' # for dialogs

  $(document).on 'keydown', (e)->
    SCROLL_SIZE = 30
    player = $('#lightbox_player')[0]
    playerHeight = $('#lightbox_player').height() - 60
    scrollHeight = Math.max(player.scrollHeight, player.clientHeight)
    $('#lightbox_player').scrollTop(player.scrollTop + SCROLL_SIZE) if e.keyCode == 40 && isLightboxMode
    $('#lightbox_player').scrollTop(player.scrollTop - SCROLL_SIZE) if e.keyCode == 38 && isLightboxMode
    $('#lightbox_player').scrollTop(player.scrollTop + playerHeight) if e.keyCode == 32 && isLightboxMode


  # move to collection
  $('.selectable-resource').on 'change', (e)->
    new_collection_id = $('option:selected', @).val()

    #update link
    collection_id = $(@).attr('data-collection-id')
    resource_id = $(@).attr('data-resource-id')
    move_path = "/collections/#{collection_id}/resources/#{resource_id}/move/#{new_collection_id}"
    $("#resource-moveto-#{resource_id}").attr('href', move_path)

  # draggable
  $('.resourceList').sortable()
  $('.resourceList').sortable('disable')
  $('.resourceList').disableSelection()
  $('.draggable').hover ->
    $('.resourceList').sortable('enable')
    $('.resourceList').disableSelection()
  , ->
    $('.resourceList').sortable('disable')
    $('.resourceList').enableSelection()
  $('.resourceList').on 'sortupdate', (e, ui)->
    collection_id = $(@).attr('data-collection-id')
    $.ajax
      data: $(@).sortable('serialize')#.replace(/resource\[\]=/g, '')
      type: 'PUT'
      url: "/collections/#{collection_id}/sort"

  # bind edit title input
  $('.resourceList_title_edit input').blur ->
    $(@).parents('.resourceList_item').removeClass('_is_editable')
  .on 'keyup', (e)->
    $(@).parents('.resourceList_item').removeClass('_is_editable') if e.keyCode == 27