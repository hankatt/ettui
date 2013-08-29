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

$(document).ready(function() {
  $('.quotes-container').gridalicious();

  $("#quotes-filter").keypress(function(press) {

    /* Using a regular get won't trigger the RJS,
       specifying the dataType as 'script' in the 
       .ajax call makes it trigger though. */

    $.ajax({
      type: 'GET',
      data: $("#quotes-filter").serialize(),
      dataType: 'script',
      url: '/quotes'
    });

    /*
    //Get character
    var character = String.fromCharCode(press.which);
    $(".search-bar .search").append(character);

    //Get search string
    var search_string = $(".search-bar .search").html();

    if(search_string.length === 1) { //Highlight everything matching the first char
      matching = $(".text:contains('" +search_string +"')").parent();
      matching.addClass('match');
    } else { //Remove .match for each letter added
      no_longer_matching = $(".match .text").not(':contains(' +search_string +')').parent();
      no_longer_matching.removeClass('match');
    }
    return false;
    */
  });

  $(".filters-list label").click(function() {
    // Mark selection as active
    $(this).toggleClass('active');

    // Set checkbox to: Checked
    checkbox = $(this).siblings('[type="checkbox"]');
    checkbox.prop('checked', !checkbox.prop('checked'));

    // Group selections and query server
    $.ajax({
      type: 'GET',
      data: $("#quotes-filter").serialize(),
      dataType: 'script',
      url: '/quotes'
    });

  })
});