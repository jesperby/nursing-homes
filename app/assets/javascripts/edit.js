jQuery(document).ready(function($) {

  $("#login-form #username").focus();

  $editForm = $("#edit-form");

  if ( $editForm.length ) {

    // Show owner and url only if private owners
    // Check value when loaded
    if ( $editForm.find(".owner_type select option:selected").attr("value") != "private" ) {
      $("div.form-row.private").hide(0);
    }

    // Check value on select change
    $editForm.find(".owner_type select").change( function(event) {
      if ( $(this).find("option:selected").attr("value") == "private") {
        $editForm.find(".form-row.private").slideDown(100);
      }
      else {
        $editForm.find(".form-row.private").slideUp(100).find('input').val("");
      }
    });

    // Sort images in edit mode
    if ( $('#sort-images').length ) {
      $('#sort-images').sortable({
        handle: 'img',
        placeholder: "placeholder"
      });
    }
  }

  $("#user_username").autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: appPath + "users/search",
        dataType: "jsonp",
        data: {
          "ldap_cn": request.term,
          items: 10
        },
        success: function( data ) {
          response( $.map( data.users, function( user ) {
            return {
              label: user.username + ", " + user.displayname,
              value: user.username,
              username: user.username,
              email: user.mail,
              displayname: user.displayname
            };
          }));
        }
      });
    },
    minLength: 5,
    select: function( event, ui ) {
      $('#user_displayname').val(ui.item.displayname);
      $('#user_email').val(ui.item.email);
    },
    open: function() {
      $(this).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
    },
    close: function() {
      $(this).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
    }
  });
});
