//= require fastclick
//= require jquery
//= require jquery_ujs
//= require_tree .

$(".o-quotes_container").on('click', function() {
  console.log("Hoping to trigger Parser:\n");
  // Parser.parse('https://thegreatdiscontent.com/interview/earlonne-woods-nigel-poor/').then(result => console.log(result));
});

$(document).on('ready DOMChange', function() {
  $(".js-toggle-sidebar").on('click', function() {
      list_to_toggle = $(this).next('ol');
      list_to_toggle.slideToggle('fast');
  });

  $(".js-toggle-menu").on('click', function() {
      $(".c-sidebar_container").toggleClass('is-open');
  });

  $(".c-segment_controller__option").on('click', toggleHidden);
});

function updateFooterGlow() {
  var footer = $(".c-landing_page__footer");
  if (!footer.length) return;
  if ($(document).height() <= $(window).height()) {
    footer.addClass('glow');
  } else {
    var scrollDistance = $(window).scrollTop();
    if (scrollDistance > 50) footer.addClass('glow');
    if (scrollDistance < 10) footer.removeClass('glow');
  }
}

$(window).scroll(updateFooterGlow);
$(window).resize(updateFooterGlow);
$(document).ready(updateFooterGlow);

$(window).load(function() {
  $(".c-landing_page__image_viewport iframe").animate({
      opacity: 1
  }, 300);
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
  siblings.fadeOut(200, function() {
      $("." +targetClass).delay(250).fadeIn();
  });
}