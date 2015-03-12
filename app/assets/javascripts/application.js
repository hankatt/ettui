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

$(function() {
    FastClick.attach(document.body);
    $.stayInWebApp('.stay');
});

/*$(window).resize(function() {
    window_width = $(window).width();
    if(window_width < 1280) {
        $(".splash-container").removeAttr('style');
    } else if(window_width > 1280) {
        $(".splash-container").height($(window).height());
        $(".splash-container").css('background-size', ('auto '+($(window).height() + 51) +'px'))
    }
});*/

$(document).on('ready DOMChange', function() {

   /* $(".splash-container").height($(window).height());
    $(".splash-container").css('background-size', ('auto '+($(window).height() + 51) +'px'))*/
    //ini();
    document.addEventListener("touchstart", function(){}, true);

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

    $(".sidebar-section-title").unbind('click').bind('click', function() {
        $(this).toggleClass('open');
        list_to_toggle = $(this).siblings('.sidebar-list');
        list_to_toggle.slideToggle(100);
    });


});