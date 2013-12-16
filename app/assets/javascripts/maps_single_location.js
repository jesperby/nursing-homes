// Show single object on inline map
jQuery(document).ready(function($) {

  var $iframe = $('<iframe scrolling="no" frameborder="0" src=""></iframe>');

  $(".show-on-map").click(function (event) {
    event.preventDefault();

    // Inject iframe with map
    $("#map").show().html($iframe.attr("src", $(this).attr("data-map-url")));

    // Scroll to content top
    $('html, body').animate({
      scrollTop: $(".main h1").offset().top - 10
    }, 200);
  });
});
