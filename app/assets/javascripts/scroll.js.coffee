scrollL0Height = 65
scrollL1Height = 170
scrollL2Height = 280
scrollLevels = [scrollL0Height, scrollL1Height, scrollL2Height]

$(document).on 'page:change', ->
  $(window).scroll ->
    for h, i in scrollLevels
      if $(window).scrollTop() >= h
        $('body').addClass '_is_scroll_L' + i
      else
        $('body').removeClass '_is_scroll_L' + i