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
//= require turbolinks
//= require turboboost
//= require jquery.blockUI
//= require bootstrap/bootstrap
//= require jquery.ThreeDots
//= require eclipsis
//= require simple
//= require wysihtml5-0.4.0pre
// require init_wysiwyg5
//= require soundmanager2
//= require soundmanager2-nodebug-jsmin
//= require soundmanager2-setup
//= require digiramp_player
//= requiry jquery.transloadit2-v2-latest
//= require recordings
//= require jquery.fancybox
//= require start_fancybox
//= require digiramp_pusher
//= require gritter
// require jquery.raty
//= require mindmup-editabletable.js
//= require ipis_table.js
//= require common_works_table.js
//= require_tree ./digi_whams
//= require sidebar
//= require recording_widget
//= require jasny-bootstrap
//= require wait_overlay
//= require share_on_facebooks
//= require moment
//= require bootstrap-datetimepicker
//= require date_picker
//= require masonry.pkgd.min
//= require masonry
//= require jquery.utilcarousel.min
//= require cocoon
//= require messages
//= require master_info
//= require jquery.fitvids
//= require fidtvideo
//= require google
//= require users
//= require icheck
//= require init-icheck
//= require contacts
//= require toggles
//= require control_panel
//= require replies
//= require jquery.linkify.min
//= require linkify
//= require cms_module
//= require jquery.slimscroll  
//= require slimscroll  
//  require signature-pad
// require bootstrap-hover-dropdown  
// require inlineplayer
// require inlineplayer-init  
// require facebook
// require bootstrapValidator.min
// require bootstrap-tokenfield
// require jquery.tokeninput
//= require chosen-jquery
//= require chosen-init
//= require user/personal_publishers
// require opengraph


Turbolinks.enableTransitionCache();

$(function () {
  // Other functions omitted.
  $(window).bind("popstate", function () {
    $.getScript(location.href);
  });
})




