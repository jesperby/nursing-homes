jQuery(document).ready(function($) {

  var $address = $( "#nursing_home_address" );
  if ( $address.length ) {
    // Autocomplete search on SBK's address API
    $( "#nursing_home_address" ).autocomplete({
      source: function( request, response ) {
        $.ajax({
          url: "//kartor.malmo.se/api/v1/addresses/",
          dataType: "jsonp",
          data: {
            q: request.term,
            items: 25
          },
          success: function( data ) {
            response( $.map( data.addresses, function( item ) {
              return {
                label: item.name + ", " + item.towndistrict,
                value: item.name,
                address: item.name,
                post_code: item.postcode,
                neighborhood: item.towndistrict,
                postal_town: item.postal_town,
                east: item.east,
                north: item.north
              };
            }));
          }
        });
      },
      minLength: 2,
      select: function( event, ui ) {
        $('#nursing_home_address').val(ui.item.address);
        $('#nursing_home_post_code').val(ui.item.post_code);
        $('#nursing_home_postal_town').val(ui.item.postal_town);
        $('#nursing_home_neighborhood').val(ui.item.neighborhood);
        $('#nursing_home_geo_position_x').val(ui.item.east);
        $('#nursing_home_geo_position_y').val(ui.item.north);
      },
      open: function() {
        $(this).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
      },
      close: function() {
        $(this).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
      }
    });

    // Don't submit the form on enter key for this field
    $('#nursing_home_address').keydown( function(event) {
      if (event.which == 13) {
        event.preventDefault();
      }
    });
  }
});
