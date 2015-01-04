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

  $('#lightbox').click ->
    quitLightbox()

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

  updateUrl = (url)->
    window.location = url

  updateLightbox = ($element)->
    $('#lightbox').removeClass()
    $('#lightbox').addClass $element.data('mime')

  $('#lightbox._is_text #lightbox_display').html marked(decodeURIComponent($('#preview-desc-value').val()))

  $(document).on 'keyup', (e)->
    if e.keyCode == 39
      keyEvent = 'right'
    if e.keyCode == 37
      keyEvent = 'left'
    if keyEvent && $('body').hasClass('present') && window.location.search
      try
        resourceIndex = window.location.search.substr(1).split('&').filter (k)->
          k.indexOf('idx') >= 0
        currentId = resourceIndex[0].split('=')[1]
        currentId = parseInt(currentId, 10)
        if currentId >= 0
          if keyEvent == 'left'
            nextId = currentId - 1
          else if keyEvent == 'right'
            nextId = currentId + 1

          console.log nextId
          if nextId >= 0
            window.location.search = "p=1&idx=#{nextId}"
      catch error
        window.location.search = ""

      