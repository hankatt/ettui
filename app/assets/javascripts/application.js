//= require fastclick
//= require jquery
//= require_tree .

$(document).on('ready DOMChange', function() {
    $(".js-toggle-sidebar").on('click', function() {
        list_to_toggle = $(this).next('ol');
        list_to_toggle.slideToggle('fast');
    });

    $(".c-segment_controller__option").on('click', toggleHidden);
});

function toggleHidden() {
    li = $(this);
    li.addClass('is-active');
    li.siblings().removeClass('is-active');

    // Fetching name of section to show
    targetClass = li.data('target');

    // Finding siblings to hide
    siblings = $("." +targetClass).siblings('.c-introduction__section');

    // Selecting and showing the section to show
    siblings.fadeOut('fast', function() {
        $("." +targetClass).delay(250).fadeIn();
    });
}
