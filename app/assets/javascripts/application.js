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

$(window).scroll(function() {
  scrollDistance = $(this).scrollTop();
  if(scrollDistance > 50) {
      $(".c-landing_page__footer").addClass('glow');
  }
  if(scrollDistance < 10) {
      $(".c-landing_page__footer").removeClass('glow');
  }
});

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