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

var active_board;

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
        //$("#search").focus();
    });

    $(".email.signup.button").on('click', function() {
        $(this).toggleClass('active');
        $(".signup-with-email").fadeToggle('fast');
    });

    /*  
        Introduction page 
    */
    $(".tutorial-steps-controls.next").on('click', function() {

        //Else
        $(".tutorial-steps-wrapper").animate({
            right: 460
        }, 670, $.easie(.33,.61,.58,1), function() {
            $(".tutorial-steps-controls.next").attr('href', '/users/done').attr('data-remote', 'true');
        });

        $(".tutorial-steps-triangle").addClass('two')

        //Switch active state to from step 1 to step 2
        $(".tutorial-steps-list li.active").removeClass('active').addClass('done');
        $(".tutorial-steps-list li.inactive").addClass('active').removeClass('inactive');
        $(".tutorial-steps-controls.next").text('Continue');
    });

    /*  
        Use keydown event to trigger backspace's, so the results updates
        as the search query is shortened. 
    */
    $("#search-filter").on('keyup', function(event) {
        search_query = $("#search").val();
        quotes = $(".quote .quote-content");

        quotes.unhighlight().highlight(search_query);
    });

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

        // Initiate variable to track active board for the new board toggle feature
        active_board = $(".header-boards-navigation li.active");

        $(".update-board-button").click(function() {
            console.log($(this).data('role'));
            if($(this).data('role') === 'edit') {
                parent = $(this).siblings('a');
                parent.attr('contenteditable', true);

                $(this).data('role', 'save');
                $(this).text('SAVE');
            } else if($(this).data('role') === 'save') {
                update_board_name();

                $(this).data('role', 'edit');
                $(this).text('EDIT');
            }
        });
});

/*  Makes sure the sidebar container has full height 
    (can't set height due to being floated) */
$(document).on('ready load resize change', function() {
    $(".sidebar-container").css('height', $(window).height() - $(".header").height());
}); 

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

function toggle_new_board() {
    active_board.toggleClass('active');
    $("li.new-board").toggleClass('inactive');
}