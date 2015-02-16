$(document).on 'page:change', ->
  return unless $('body').is('#landings')

  CREATE_INTERVAL = 3000
  RESET_INTERVAL = 12000
  readyHandler = null

  scrollToPage = (page)->
    $('#landingPage').removeClass '_is_ready'
    $('#landingPage').attr('page', page)#.addClass '_is_ready'
    $('body').removeClass()
    $('body').addClass("_is_scroll_L#{page}")

    readyHandler = setTimeout ->
      clearTimeout readyHandler
      $('#landingPage').addClass '_is_ready'
    , 1400
    gif = $("#landingPage_p#{page} .landingPage_gif img")
    gif.attr 'src', gif.parents('.landingPage_gif').attr('src')

  setOnScroll = ->

    #detect scrolling
    scrollToPage(0)
    $(window).on 'mousewheel', (e)->
      handleWheelEvent(e.originalEvent.wheelDelta)
      
  
  handleWheelEvent = (delta)->
    return unless $('#landingPage').hasClass '_is_ready'
    page = parseInt($('#landingPage').attr('page'))
    if delta/120 > 0 && page > 0
      scrollToPage(page - 1)
    else if delta/120 < -0 && page < 3
      scrollToPage(page + 1)

  resetRing = (width, height, ringDiameter, ring)->
    $(ring).css('width', ringDiameter);
    $(ring).css('height', ringDiameter);
    $(ring).css('left', Math.random()* width * 0.9)
    $(ring).css('top', Math.random() * height * 0.9)

  loopIndex = 0
  creationLoop = (width, height)->
    setTimeout ->
      ring = $('.ring').get(loopIndex)
      $(ring).removeClass('_is_inited')
      setTimeout ->
        ringDiameter = 50 + 100 * Math.random()
        setTimeout ->
          resetRing(width, height, ringDiameter, ring)
        , RESET_INTERVAL
        $(ring).addClass('_is_inited')
        # $(ring).removeClass('_is_hovered')
        $(ring).removeClass('_is_orange').removeClass('_is_purple').removeClass('_is_lime')
      , RESET_INTERVAL

      creationLoop(width, height)
      loopIndex += 1
      loopIndex = 0 if loopIndex == $('.ring').length
    , CREATE_INTERVAL


  initRings = (target)->
    rings = target.find('.ring')
    width = target.width()
    height = target.innerHeight()
    colors = ['_is_orange', '_is_purple', '_is_lime']

    rings.each (i)->
      ringDiameter = 50 + 100 * Math.random();
      resetRing(width, height, ringDiameter, @)
      $(@).on 'mouseenter', ->
        $(@).addClass colors[Math.floor(Math.random()*colors.length)]
        # $(@).addClass '_is_hovered'

      
    creationLoop(width, height)

  #main
  setOnScroll()
  initRings($('.ringsContainer'))

  $('form').keydown (e)->
    if e.keyCode == 13
      $(@).submit()

  $('.landingPage_signup').click ->
    $('#pwd_conf').val $('#pwd').val()
    $(@).parents('form').submit()

  $('.landingPage_gif img').click ->
    $(@).attr 'src', $(@).parent().attr('src')

  $('.landingPage_indicator').click ->
    scrollToPage $(@).index()