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
        //ini();
    });
    
    /*  
        Use keydown event to trigger backspace's, so the results updates
        as the search query is shortened. 
    
    $("#search-filter .search").on('keyup', function(event) {
        search_query = $(this).val();
        quotes = $(".quote .quote-content");

        quotes.unhighlight().highlight(search_query);
    });
    
    */

    $(".sidebar-toggle-column, .sidebar-toggle").on('click', function(event) {
        if(!$("#search-filter").hasClass('active')) {
            $("#search-filter").addClass('active');
            $(".sidebar-toggle-column").hide();
            $(".sidebar-toggle").fadeOut(70);
        }
    });

    $(document).on('click', function(event) {
        if($("#search-filter").hasClass('active') && $(event.target).hasClass('content-container')) {
            $(".sidebar-toggle").fadeIn(70);
            $(".sidebar-toggle-column").fadeIn();
            $("#search-filter").removeClass('active');
        }

        if($(".popup.active").length > 0 && $(event.target).hasClass('content-container')) {
            $(".popup.active").removeClass('active');
        }
    });

    $(".sidebar-title-toggle").on('click', function() {
        $(this).toggleClass('active');
        list_to_toggle = $(this).siblings('.sidebar-list');
        list_to_toggle.slideToggle(100);
    });

    $("li.existing-tag").unbind('click').on('click', function() {
        quote = $(this).parent().parent().parent();
        tag_exists = false;
        clicked_tag = $(this).text();
        $(".quote-options.q-" +quote.data('qid') +" .quote-tag").each(function() {
            if(clicked_tag === $(this).children('.tag').text())
                tag_exists = true;
        });

        if(!tag_exists) {

            // Show the clicked tag as selected in the popup
            $(this).addClass('selected');

            // Params for the AJAX query
            var params = {
                qid: quote.data('qid'),
                tag: $(this).text(),
                is_new: false
            }

            $.ajax({
                url: "//localhost:3000/add/ltag",
                dataType: "script",
                data: jQuery.param(params)
            });
        }
    });

    $(".popup-new-tag-submit").unbind('click').on('click', function (e) {
        e.preventDefault();
        new_tag = $(this).siblings(".popup-new-tag");

        console.log(".popup-new-tag-submit");

        tag_exists = false;
        $(".popup.active ul li").each(function() {
            if(new_tag.val() === $(this).text())
                tag_exists = true;
        });

        if(tag_exists) {
            new_tag.val(''); //Reset input field
        } else {
            var params = {
                qid: new_tag.data('qid'),
                tag: new_tag.val(),
                is_new: true
            }

            $.ajax({
                url: "//localhost:3000/add/ltag",
                dataType: "script",
                data: jQuery.param(params)
            });

        }
    });

    /* 
        Checkbox functionality for the source filters 
    */

    $(".filters-list li, .tags-list li").on('click', function(e) {

        // Mark selection as active
        $(this).toggleClass('active');

        // Set checkbox to: Checked
        checkbox = $(this).children('[type="checkbox"]');
        checkbox.prop('checked', !checkbox.prop('checked'));
        $(".filters-list li, .tags-list li").unbind('click');
    });

});

$(document).on('click', '.add-tag.button', function() {
    popup = $(this).parent().parent().parent().children('.popup');
    setTimeout(function(){
        popup.children('.popup-new-tag').focus();
    }, 0);

    if(popup.hasClass('active'))
        popup.removeClass('active')
    else {
        $(".popup.active").removeClass('active');
        popup.addClass('active');
    }
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