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

$(document).on('ready DOMChange', function() {

    //ini();

    $(window).resize(function () {
        if($(document).outerWidth() < 936 && $("#search-filter").hasClass('active'))
            $("#search-filter").removeClass('active');
    });

    $(".sidebar-toggle-column, .sidebar-toggle").on('click', function(event) {
        if(!$("#search-filter").hasClass('active')) {
            $("#search-filter").addClass('active');
            $(".sidebar-toggle-column").hide();
            $(".sidebar-toggle").fadeOut(70);
        }
    });

    $(document).on('click', function(event) {
        if($("#search-filter").hasClass('active') && $(".popup").length == 0 && ($(event.target).hasClass('content-container') || $(event.target).hasClass('quotes-container'))) {
            $(".sidebar-toggle").fadeIn(70);
            $(".sidebar-toggle-column").fadeIn();
            $("#search-filter").removeClass('active');
        }

        if($(".popup").length > 0 && ($(event.target).hasClass('content-container') || $(event.target).hasClass('quotes-container') || $(event.target).hasClass('quote') || $(event.target).hasClass('sidebar-container') || $(event.target).hasClass('quote-content'))) {
            $(".popup").fadeOut('fast', function() {
                $(".popup").remove();
            });
        }
    });

    $(".quote.unread").mouseenter(function() {
        $(this).find('.symbol-new').fadeOut(200, function() {
            $(this).parents(".quote.unread").removeClass("unread");
        });
    });

    $(".sidebar-section-title").unbind('click').on('click', function() {
        $(this).toggleClass('active');
        list_to_toggle = $(this).siblings('.sidebar-list');
        list_to_toggle.slideToggle(100);
    });

    $(".unused-tags > li").unbind('click').on('click', function(e) {
        e.preventDefault();

        tag = $(this);

        updateTag({
            qid: tag.data('qid'),
            tag: tag.text()
        });

        // Show the clicked tag as selected in the popup
        $(this).addClass('selected');
    });


    /* 
        ADD new custom tag,
        BUT make sure it's not already used on the current quote. (server-side)
    */

    $(".popup-new-tag-submit").unbind('click').on('click', function (e) {
        e.preventDefault();
        inputfield = $(this).siblings(".popup-new-tag");

        updateTag({
            qid: inputfield.data('qid'),
            tag: inputfield.val()
        });

        //if(tag_exists)
            //Reset input field
            //Flash the tag on the quote to highlight its presence
    });


    /* 
        Checkbox functionality for the source filters 
    */

    $(".sidebar-list li").unbind('click').on('click', function(e) {
        // Mark selection as active
        $(this).toggleClass('active');

        // Set checkbox to: Checked
        checkbox = $(this).children('[type="checkbox"]');
        checkbox.prop('checked', !checkbox.prop('checked'));
    });

});

function updateTag(params) {
    $.ajax({
        url: "//localhost:3000/add/ltag",
        dataType: "script",
        data: jQuery.param(params)
    });
}

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