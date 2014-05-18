var incomingUpdate = function() {}; // SBK Maps iframe can call the incomingUpdate() ping function so we can update "My list"

// Listen for "My list" changes
jQuery(document).ready(function($) {
  // Called from SBK Maps iframe when a change to the "My list" is made
  incomingUpdate = function() {
    // The map write to the cookie so we need to read it first
    read();
    checkTheBoxes();
    updateStatus();
  };

  var itemsIds = [];
  // Get itemsIds from cookie
  // Used onload and when the SBK Maps changes the ids
  var read = function() {
    if (!!$.cookie('nursing_homes_compare')) {
      itemsIds = $.cookie('nursing_homes_compare').split("|");
      clean();
    } else {
      itemsIds = [];
    }
  };

  // Set cookie with itemsIds separated by a pipe
  var store = function() {
    clean();
    updateStatus();
    $.cookie( 'nursing_homes_compare', itemsIds.join("|"), { expires: 365, domain: "malmo.se", path: "/" } );
  };

  // Add an id to itemsIds
  var addItem = function(id) {
    itemsIds.push(id);
    store();
  };

  // Remove an id from itemsIds
  var removeItem = function(id) {
    delete itemsIds[ $.inArray(id, itemsIds) ];
    store();
  };

  // Update "Min lista"
  var updateStatus = function() {
    var $statusList = $("#my-list .status-list");
    $statusList.empty();
    if ( itemsIds && itemsIds.length > 0) {
      $statusList.append("<ul>");
      $.each(itemsIds, function(index, id) {
        $statusList.find("ul").append(
          $("<li>").append( $("<a>").attr("href", nursingHomePath + id).text(nursingHomes[id]) ).prepend(
            $("<span class='remove m-icon-close'>").attr( { "data-id": id, "title": "Ta bort" } )
          )
        );
      });
      $("#my-list .compare").show();
      $("#my-list .how-to").hide();
    } else {
      $("#my-list .compare").hide();
      $("#my-list .how-to").show();
    }
  };

  // Since the cookie is read and written from two apps, this and SBK Maps,
  // we better clean it up before certain actions
  // Also clean objects in "My List" that are deleted from the system.
  var clean = function() {
    // Convert all itemsIds to strings before sorting
    itemsIds = itemsIds.join("|").split("|").sort();

    // Collect existing objects ids
    var allIds = [];
    $.each( nursingHomes, function(k, v) { allIds.push(k); });

    itemsIds = $.map(itemsIds, function(id, index) {
      // Return item if it's not empty and the same as the next one
      if (id !== itemsIds[index + 1] && !!id && $.inArray(id, allIds) !== -1 ) {
        return id;
      }
    });
  };

  // Check checkboxes if the id is in itemsIds
  // Used onload and when the SBK Maps changes the ids
  // Note: All checkboxes must be in a "div.compare-check" container
  var checkTheBoxes = function() {
    $( "div.compare-check input" ).each( function() {
      if ( $.inArray($(this).attr("data-compare"), itemsIds) !== -1 ) {
        $(this).attr('checked', true );
      } else {
        $(this).attr('checked', false);
      }
    });
  };

  // Change bg on hover
  $("#my-list").on("mouseenter mouseleave", ".remove", function() {
    $(this).toggleClass("m-icon-close m-icon-close-0");
  });

  // Remove in the compare box
  $("#my-list .status-list").on('click', 'li .remove', function() {
    removeItem( $(this).attr('data-id') );
    checkTheBoxes();
  });

  // Listen to changes in users compare list
  $( "div.compare-check input" ).change( function(event) {
    var id = $(this).attr("data-compare");
    if ( $(this).is(':checked') ) { addItem(id); }
    else { removeItem(id); }
  });

  // User removes an item from the compare view
  $("#compare .remove").click( function() {
    var id = $(this).attr('data-id');
    removeItem(id);

    // Hide each th and td for the items data. Use the item-id class
    jQuery("#compare th[colspan], #compare td[colspan]").each( function() {
      jQuery(this).attr( "colspan", jQuery(this).attr("colspan") );
    });
    $("#compare .item-" + id).fadeOut();
  });

  // Get all nursing homes from the json api to populate the users compare menu
  var nursingHomes = {};
  $.ajax({
    url: apiPath,
    dataType: "jsonp",
    data: { fields: "id,name" },
    cache: true,
    jsonpCallback: "foo", // so browser can cache the response
    success: function( data ) {
      $.each(data.nursing_homes, function(index, item) {
        nursingHomes[item.id] = item.name;
      });
      // We have the data, now use it in the UI
      read();
      checkTheBoxes();
      updateStatus();
    }
  });

});
