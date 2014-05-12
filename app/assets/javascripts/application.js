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
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require handlebars
//= require jquery-ui.highlight
//= require typeahead.bundle
//= require bootstrap-datepicker
//= require bootstrap-datepicker-pl
//= require init_librarian_module
//= require check_out
//= require main
//= require_tree .


$(document).ready(function () {
  Librarian.checkOut = new Librarian.classes.CheckOut;
});
