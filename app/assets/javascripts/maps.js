// updateMap() is called when filtering and selecting the map tab
var updateMap = function(){};
var injectMap = function(){};

jQuery(document).ready(function($) {
  document.domain = "malmo.se"; // must be set both here and in the map iframe

  // mapUrl is set in <head> by rails
  // mapUrl = "http://webapps2.malmo.se/_nh/iframe.html"; // sub-domain iframe communication test case
  var $mapIframe = $('<iframe scrolling="no" frameborder="0" src="" id="inline-map"></iframe>');

  // Inject map iframe
  injectMap = function() {
    var ids = !!filtered_items ? filteredIds.join(",") : "0";
    $mapIframe.appendTo($("#tab-element-map")).attr("src", mapUrl + "&ids=" + ids);
  };

  // Update with nursing homes ids filtered by the user, or all
  updateMap = function() {
    // Call SBK's function to update the map
    // The SBK map shows all nursing homes for null, none for [] and some for [1,3,4]
    if (typeof showWithIds === "function") {
      var arg = filteredIds;
      if (filtered_items === 0) arg = [];
      else if ( filtered_items == total_items ) arg = "";
      showWithIds( arg );
    }
  };

  // Show filtered nursing homes on map after loading
  $mapIframe.load( function() {
    updateMap();
  });

  // Show single object on map in a lightbox
  $( "#show-address-on-map" ).click( function (event) {
    event.preventDefault();
    $.malmo.map.showLocation($(this).attr('title'));
  });
});
