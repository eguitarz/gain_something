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

  $('.embed').click (e)->
    # $('body').addClass 'present'
    # window.history.pushState(null, 'GS', $(@).data('base-url'))
    # updateLightbox($(@))
    window.location = $(@).data('base-url')

  quitLightbox = ->
    $('iframe').first().attr('src', '')
    $('#lightbox .player .content').html ''
    $('body').removeClass 'present'
    $('#lightbox').removeClass()

    newUrl = window.location.href.replace(window.location.search, '')
    window.history.pushState(null, 'GS',  newUrl)

  # prevent passing click event to #lightbox
  $('#lightbox_player, #lightbox_previous_button, #lightbox_next_button').click (e)->
    e.stopPropagation();

  $('#lightbox').click ->
    quitLightbox()

  $('#lightbox .btn-close').click ->
    quitLightbox()

  $('#lightbox_previous_button').click ->
    setNextItemInLightbox(getCurrentId(), false)

  $('#lightbox_next_button').click ->
    setNextItemInLightbox(getCurrentId(), true)

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

  updateUrl = (url)->
    window.location = url

  updateLightbox = ($element)->
    $('#lightbox').removeClass()
    $('#lightbox').addClass $element.data('mime')

  $('#lightbox._is_text #lightbox_display').html marked(decodeURIComponent($('#preview-desc-value').val()))

  getResourceCount = ()->    
    parseInt( $('#lightbox_resource_count').val(), 10)

  getCurrentId = ()->
    try
      resourceIndex = window.location.search.substr(1).split('&').filter (k)->
        k.indexOf('idx') >= 0
      currentId = resourceIndex[0].split('=')[1]
      currentId = parseInt(currentId, 10)
    catch error
      return -1

  hasPreviousItem = ()->
    getCurrentId() > 0

  hasNextItem = () ->
    getCurrentId() < getResourceCount() - 1

  if hasPreviousItem()
    $('#lightbox_previous_button').removeClass 'hide'
  else
    $('#lightbox_previous_button').addClass 'hide'

  if hasNextItem()
    $('#lightbox_next_button').removeClass 'hide'
  else
    $('#lightbox_next_button').addClass 'hide'

  setNextItemInLightbox = (id, isNext)->
    nextId = if isNext then id + 1 else id - 1
    if nextId >= 0 && nextId < getResourceCount()
      window.location.search = "p=1&idx=#{nextId}"

  $(document).on 'keyup', (e)->
    if e.keyCode == 39
      keyEvent = 'right'
    if e.keyCode == 37
      keyEvent = 'left'
    if e.keyCode == 27
      quitLightbox()

    if keyEvent && $('body').hasClass('present') && window.location.search 
      currentId = getCurrentId()
      if currentId >= 0
        if keyEvent == 'left'
          setNextItemInLightbox(currentId, false)
        else if keyEvent == 'right'
          setNextItemInLightbox(currentId, true)

          

      