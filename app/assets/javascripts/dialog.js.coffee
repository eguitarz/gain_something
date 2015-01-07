$(document).on 'page:change', ->
  $('#confirmDialog_buttons_cancel > .btn-no, #overlay').on 'click', (e)->
    $('body').removeClass '_is_confirmation'
    
  $('#confirmDialog_buttons_confirm > .btn-yes').on 'click', (e)->
    link = $('#' + $('#confirmDialog').data('resource-id'))
    $.rails.confirmed(link)