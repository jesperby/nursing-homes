jQuery(document).ready(function($) {

  // Plaitext textarea and ckeditor with Twitter style chars counters
  var $description = $('#nursing_home_description');
  if ( $("#edit-form").length && $description.length ) {

    // CKEditor instance
    var descEditor = CKEDITOR.replace('nursing_home_description', {
      toolbar: [['Format']],
      format_tags: 'p;h2',
      skin: 'kama',
      uiColor: '#f5f5f5',
      stylesSet: [],
      contentsCss: appPath + 'assets/editors.css',
      forcePasteAsPlainText: true,
      keystrokes: [],
      entities: false,
      htmlEncodeOutput: false,
      forceSimpleAmpersand: true,
      removePlugins: 'elementspath,resize,embed,dialog,attachment',
      toolbarCanCollapse: false,
      language: 'sv',
      height: '22em',
      // width: '100%'
    });

    descEditor.on( "focus", function() {
      $description.timer = setInterval( function() {
        // // Word count alternative
        // var contentText = $(descEditor.getSnapshot()).text();
        // var numberOfWords = !contentText ? 0 : (contentText.split(/^\s+$/).length === 2 ? 0 : 2 + contentText.split(/\s+/).length - contentText.split(/^\s+/).length - contentText.split(/\s+$/).length);
        // showCount( $description, numberOfWords, 150);
        // showCount( $description, $(descEditor.getSnapshot().replace(/></g,"> <")).text().replace(/\r+/g, "").replace(/\s+/g, " ").trim().length, 700);

        // All none tag characters are counted including spaces, i.e each keyup should increase/decrease the counter
        showCount( $description, $(descEditor.getSnapshot().replace(/&nbsp;/g," ").replace(/(<\/.+?>)</g,"$1 <")).text().length, 750);
      }, 100);
    });

    descEditor.on( "blur", function() {
      clearInterval($description.timer);
    });

    // Regular plain textarea
    // Note: keydown/up will not do, it is possible to perform cut/paste from browser menu
    $("#nursing_home_standard").focus(function() {
      $field = $(this);
      $field.timer = setInterval( function() {
        showCount( $field, $field.val().length, 150 );
      }, 100);
    });

    $("#nursing_home_standard").blur(function() {
      $field = $(this);
      clearInterval($field.timer);
    });
  }

  function showCount($field, chars, limit) {
    $count = $field.closest(".control-group").find(".count");
    $count.html(limit - chars + " av " + limit + " tecken kvar");

    if ( limit - chars < 0 ) {
      $count.attr("class", "count too-much");
    }
    else if ( limit - chars < 10 ) {
      $count.attr("class", "count warn");
    } else {
      $count.attr("class", "count ok");
    }
  }
});
