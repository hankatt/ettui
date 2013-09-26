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

$(document).on('ready', function() {

    /* 
      Initialize Masonry 
    */

    var $container = $('.quotes-container');
    // initialize
    $container.masonry({
        columnWidth: 520,
        itemSelector: '.quote'
    });

    /*  
        Whenever the user start to write, it should go into the search field. 
    */
    $(window).on('keypress', function(event) {
        $("#search").focus();
    });

    /*  
        Use keydown event to trigger backspace's, so the results updates
        as the search query is shortened. 
    */
    $("#search-filter").on('keydown', function(event) {
        search();
    });

    /* 
        Checkbox functionality for the source filters 
    */
    $(".filters-list button").click(function() {
        // Mark selection as active
        $(this).toggleClass('active');

        // Set checkbox to: Checked
        checkbox = $(this).siblings('[type="checkbox"]');
        checkbox.prop('checked', !checkbox.prop('checked'));
        });

        /* In responsive mode, this reveals the menu. */
        $(".menu-button").on('click', function() {
        $(".sidebar, .filters-container").toggleClass('active');
    });
});

/*  Makes sure the sidebar container has full height 
    (can't set height due to being floated) */
$(document).on('ready load resize change', function() {
  $(".sidebar-container").css('height', $(window).height());
}); 

/* Performs the AJAX search. */
function search() {
  data = $("#search-filter").serialize();

  // Specifying the dataType as 'script' in the $.ajax call to trigger RJS.
  $.ajax({
      type: 'GET',
      data: data,
      dataType: 'script',
      url: '/quotes'
  });
}