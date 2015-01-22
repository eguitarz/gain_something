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
//= require jquery-ui
//= require modernizr
//= require codemirror
//= require active-line
//= require placeholder
//= require meta
//= require markdown
//= require marked
//= require turbolinks
//= require_tree .

$(document).on('page:change', function() {
  window.GS = {};
  $.rails.allowAction = function(link) {
    if(link.attr('data-modal') == 'true') {
      $('body').addClass('_is_confirmation')
      $.rails.showConfirmDialog(link, link.data('method') == 'delete');
      return false;
    } else {
      return true;
    }
  };

  $.rails.confirmed = function(link) {
    var confrimMsg = link.attr('data-confirm');
    link.attr('data-modal', 'false')
    $('body').removeClass('_is_confirmation');
    link.trigger('click.rails');
  };

  $.rails.showConfirmDialog = function(link, isDeletion) {
    console.log(link);
    console.log(link.attr('data-confirm'));
    var message = link.attr('data-confirm');
    $('#confirmDialog_text').text(message);
    $('#confirmDialog').data( 'resource-id', link.attr('id') )
    $('.btn-yes').removeClass('btn-error').removeClass('btn-success');
    
    if (isDeletion) {
      $('.btn-yes').addClass('btn-error');
    }
    else {
      $('.btn-yes').addClass('btn-success');
    }
  };

  $('body').removeClass('_is_preloading');

});