// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require codemirror
//= require active-line
//= require placeholder
//= require meta
//= require markdown
//= require marked
//= require turbolinks
//= require_tree .

$(document).ready( function() {
window.GS = {};
$.rails.allowAction = function(link) {
  if(link.attr('data-confirm')) {
    $('body').addClass('_is_confirmation')
    $.rails.showConfirmDialog(link);
    return false;
  } else {
    return true;
  }
};

$.rails.confirmed = function(link) {
  link.removeAttr('data-confirm')
  $('body').removeClass('_is_confirmation');
  link.trigger('click.rails');
};

$.rails.showConfirmDialog = function(link) {
  var message = link.data('confirm');
  $('#confirmDialog').data( 'resource-id', link.attr('id') )
  $('#confirmDialog_text').text(message);
};

});