jQuery(document).ready(function($) {

  // Create tabs, one for the list and one for the map
  var $tabContainer = $("#tab-element-container");
  if ($tabContainer.length) {
    $tabContainer.tabs( {
      selected: 0,
      select: function(event, ui) {
        // Inject map if not already done
        if ( $(ui.tab).attr('href') == "#tab-element-map" && !$("#tab-element-map iframe").length ) {
          injectMap();
        }
      }
    });
  }
});
