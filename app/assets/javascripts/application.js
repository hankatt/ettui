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
    document.addEventListener("touchstart", function(){}, true);

    $(".sidebar-close").unbind('click').bind('click', function(event) {
        $("#search-filter").removeClass('active');
    });

    $(".segment-control").unbind('click').bind('click', function(e) {
        $(this).addClass('active');
        $(".segment-control").not(this).removeClass('active');

        index = $(this).index();
        contentContainer = $(this).parent().siblings('.segmented-content-viewport');

        sc = contentContainer.find('.segmented-content:eq(' +index +')');
        scrollDistance = sc.width() + 20;
        if($(window).width() < 768) contentContainer.addClass('mobile');
        if(contentContainer.hasClass('mobile')) {
            contentContainers = contentContainer.find('.segmented-content');
            contentContainers.css('transform', 'translateX(-' +(scrollDistance * index) +'px)');
        } else {
            contentContainer.animate({
                scrollLeft : scrollDistance * index
            }, 200);
        }

    });

    $(".sidebar-toggle-column, .sidebar-toggle").on('click', function(event) {
        if(!$("#search-filter").hasClass('active')) {
            $("#search-filter").addClass('active');
            $(".sidebar-toggle").fadeOut(70);
        }
    });

    $(window).mouseup(function(e) {
        if($("#search-filter").hasClass('active')) {
            var container = $(".sidebar-container");
            var exceptions = $(".quote");
            if (!container.is(e.target) && container.find(e.target).length === 0 && exceptions.find(e.target).length === 0) {
                $(".sidebar-toggle").fadeIn(70);
                $(".sidebar-toggle-column").fadeIn();
                $("#search-filter").removeClass('active');
            }
        }
    });

    $(document).on('click', function(event) {
        if($(".popup").length > 0 && ($(event.target).hasClass('content-container') || $(event.target).hasClass('quotes-container') || $(event.target).hasClass('quote') || $(event.target).hasClass('sidebar-container') || $(event.target).hasClass('quote-content'))) {
            $(".popup").fadeOut('fast', function() {
                $(".popup").remove();
            });
        }
    });

    $("a.append-tag").unbind('click').bind('click', function(event) {
        // Don't follow through on the link
        event.stopPropagation();
        event.preventDefault();

        // Necessary param for the query
        params = { 
            id: $(this).parents('.quote').data('qid')
        };

        $.ajax({
            url: "//notedapp.herokuapp.com/add/tag_input",
            dataType: "script",
            data: jQuery.param(params)
        });

    });

    $(".quote.unread").mouseenter(function() {
        $(this).find('.symbol-new').fadeOut(200, function() {
            $(this).parents(".quote.unread").removeClass("unread");
        });
    });

    $(".sidebar-section-title").unbind('click').bind('click', function() {
        $(this).toggleClass('open');
        list_to_toggle = $(this).siblings('.sidebar-list');
        list_to_toggle.slideToggle(100);
    });


    /* 
        ADD new custom tag,
        BUT make sure it's not already used on the current quote. (server-side)
    */

    $(".popup-new-tag-submit").unbind('click').bind('click', function (e) {
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

    $("#search").keypress(function() {
        $(".sidebar-list li").unbind('click');
    });

    /* 
        Checkbox functionality for the source filters 
    */

    $(".sidebar-list-item").unbind('click').bind('click', function(e) {
        // Mark selection as active
        $(this).toggleClass('active');

        // Set checkbox to: Checked
        checkbox = $(":checkbox", this);
        checkbox.prop('checked', !checkbox.prop('checked'));
    });

    $("#selectBookmarkletCode").on('click', function() {
        selectText('bookmarkletCode');
    });

});

function selectText(element) {
    var doc = document,
        text = doc.getElementById(element),
        range,
        selection;

    if (doc.body.createTextRange) {
        range = document.body.createTextRange();
        range.moveToElementText(text);
        range.select();
    } else if (window.getSelection) {
        selection = window.getSelection();        
        range = document.createRange();
        range.selectNodeContents(text);
        selection.removeAllRanges();
        selection.addRange(range);
    }
}

function updateTag(params) {
    $.ajax({
        url: "//notedapp.herokuapp.com/add/tag_locally",
        dataType: "script",
        data: jQuery.param(params)
    });
}