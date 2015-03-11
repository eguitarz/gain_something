$(document).on 'page:change', ->
  if $('body').hasClass '_is_lightbox_mode'
    $('#lightbox._is_text .lightbox_player_html').html(marked(decodeURIComponent($('#lightbox-markdownDescription').val()), {breaks: true}));
  $('#lightbox_previous_button').css('top', $(window).innerHeight()/2)
  $('#lightbox_next_button').css('top', $(window).innerHeight()/2)