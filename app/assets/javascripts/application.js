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
    $(".sidebar-container").mouseenter(function() {
        if(!$("#search-filter").hasClass('active'))
            $("#search-filter").addClass('active');
    });

    $(".sidebar-container").mouseleave(function() {
        if($("#search-filter").hasClass('active'))
            $("#search-filter").removeClass('active');
    });
    */

    /*  
        Use keydown event to trigger backspace's, so the results updates
        as the search query is shortened. 
    
    $("#search-filter .search").on('keyup', function(event) {
        search_query = $(this).val();
        quotes = $(".quote .quote-content");

        quotes.unhighlight().highlight(search_query);
    });
    
    */

    /*
    $(".quote").hover(function() {
        $(this).children('.quote-content').children('.quote-actions').slideDown('fast'); 
    }, function() {
        $(this).children('.quote-content').children('.quote-actions').slideUp('fast');
    })
    */

    /* 
        Checkbox functionality for the source filters 
    */
    $(".filters-list li").click(function() {
        // Mark selection as active
        $(this).toggleClass('active');

        // Set checkbox to: Checked
        checkbox = $(this).children('[type="checkbox"]');
        checkbox.prop('checked', !checkbox.prop('checked'));
        });

        /* In responsive mode, this reveals the menu. */
        $(".menu-button").on('click', function() {
            $(".sidebar, .filters-container").toggleClass('active');
        });
});

$(window).scroll(function() {
    $(".sidebar-content").css('margin-top', $(window).scrollTop());
})

/* Performs the AJAX search.

function search() {
  data = $("#search-filter").serialize();

  // Specifying the dataType as 'script' in the $.ajax call to trigger RJS.
  $.ajax({
      type: 'GET',
      data: data,
      dataType: 'script',
      url: window.location.pathname
  });
}

*/

/* Update a contenteditable field.

function update_board_name() {
    name = $("[contenteditable]").text();
    id = $("[contenteditable]").data('id');

    $.ajax({
        type: 'PUT',
        data: { name: name },
        dataType: 'script',
        url: "/boards/" + id
    })
}

*/