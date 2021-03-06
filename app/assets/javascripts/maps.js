jQuery(document).ready(function($) {
  document.domain = "malmo.se"; // must be set both here and in the map iframe

  // mapUrl is set on the html page
  var $mapIframe = $('<iframe scrolling="no" frameborder="0" src=""></iframe>');

  // Inject map iframe
  injectMap = function() {
    var ids = !!filtered_items ? filteredIds.join(",") : "0";
    $mapIframe.appendTo($("#map")).attr("src", mapUrl + "&ids=" + ids);
  };

  // Update with nursing homes ids filtered by the user, or all
  window.updateMap = function() {
    // Call SBK's function to update the map
    // The SBK map shows all nursing homes for null, none for [] and some for [1,3,4]
    if (typeof showWithIds === "function") {
      var arg = filteredIds;
      if (filtered_items === 0) arg = [];
      else if (filtered_items == total_items) arg = "";
      showWithIds( arg );
    }
  };

  // Show filtered nursing homes on map after loading
  $mapIframe.load( function() {
    updateMap();
  });

  $('#as-map').click(function(event) {
    event.preventDefault();
    $(this).addClass("active");
    $("#as-list").removeClass("active");
    $('#map').show();
    $('ul.results').hide();
    injectMap();
  });

  $('#as-list').click(function(event) {
    event.preventDefault();
    $(this).addClass("active");
    $("#as-map").removeClass("active");
    $('#map').hide();
    $('ul.results').show();
  });
});
