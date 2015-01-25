$(document).on 'page:change', ->
  if $('body').hasClass '_is_lightbox_mode'
    $('#lightbox._is_text .lightbox_player_html').html(marked(decodeURIComponent($('#lightbox-markdownDescription').val())));