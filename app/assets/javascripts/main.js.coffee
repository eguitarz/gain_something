$(document).on 'page:change', ->
  # timeout is to prevent not showing collapsing animation
  setTimeout ->
    $('#notifier').addClass '_is_hide'
  , 0