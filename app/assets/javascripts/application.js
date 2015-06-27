//= require fastclick
//= require jquery
//= require_tree .

$(document).on('ready DOMChange', function() {
    $(".js-toggle-sidebar").on('click', function() {
        list_to_toggle = $(this).next('ol');
        list_to_toggle.slideToggle('fast');
    });
});
