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
//= require fastclick
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).on('ready DOMChange', function() {

});

scrollingDistance = 0;
$(document).on({
    mouseenter: function() {
        scrollingDistance = $(document).scrollTop();
        $(".container").addClass('is-scroll_locked');
        distanceFromLeft = $(".container").width() - $(".c-sidebar_container").outerWidth() - $(".o-content_container").outerWidth()
        $(".o-content_container").css('left', distanceFromLeft/2);
        $(".o-content_container").css('top', -scrollingDistance);
    },
    mouseleave: function() {
        console.log("mouseleave sd: " +scrollingDistance);
        $(".container").removeClass('is-scroll_locked');
        $(document).scrollTop(scrollingDistance);
    }
}, ".c-sidebar_container"); 