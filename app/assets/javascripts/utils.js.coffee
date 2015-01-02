window.isPrintableKeycode = (keycode)->
  valid = (keycode > 47 && keycode < 58) || keycode == 32 || keycode == 13 || keycode == 8 || (keycode > 64 && keycode < 91)  \
    || (keycode > 95 && keycode < 112) || (keycode > 185 && keycode < 193) || (keycode > 218 && keycode < 223)