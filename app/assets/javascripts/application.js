// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(window).load(function() {
  $('#quotes-container').masonry({
    // options
    itemSelector : '.quote',
    columnWidth : 280,
    gutterWidth : 40,
    isAnimated : true
  });
});

$(document).ready(function() {
});

function reload() {
  window.location.reload();
}

/*  
  $(".quote").hover(function() {
    $(this).children(".quote-details").show();
  });

  $(".quote").mouseleave(function() {
    $(this).children(".quote-details").hide();
  });

  $("#close-wizard").click(function() {
    toggle_instructions();
  });
});

function toggle_instructions() {
  $("#wellsaid-wizard").slideToggle()
}
*/