// User filtering and search are based on data-* attributes attatched to each nursing home's li
// HTML5 data-x binding used as an alternative to send out an js array to work on

// Ids after user filtering, used when creating or updating the map and the status text
var filteredIds = [];
var filtered_items;
var total_items;

jQuery(document).ready(function($) {
  var filter = {};
  var $filterForm = $("#filter-form");

  // Put updateList() in a global scope so the map service can call it. Hard coupling.
  window.updateList = updateList;

  if ($filterForm.length) {

    var $listItems = $("ul.results li");
    // Number of nursing homes in the list
    total_items = $listItems.length;
    filtered_items = total_items;

    // Set filter based on cookie
    setFilter();

    // Filter nursing homes list on filter form change
    $filterForm.find("select").change(function() {
      readFilterForm();
      updateList();
      saveFilter();
    });
  }

  // Perform filtering based on data-x attributes in the nursing homes list
  function updateList() {
    // Build a somewhat complex selector to show/hide the nursing homes
    var selector = "";
    if (!!filter.neighborhood) selector += "[data-neighborhood='" + filter.neighborhood + "']";
    // category id's are surrounded by pipes. Check if the data-category contains the category id.
    if (!!filter.category) selector += "[data-category*='|" + filter.category + "|']";
    if (!!filter.owner_type) selector += "[data-owner_type='" + filter.owner_type + "']";
    // All select menues reset by the user?
    if (!selector) {
      resetList();
    }
    else {
      filteredIds = [];
      filtered_items = 0;
      $listItems.each(function() {
        $this = $(this);
        if ($this.is(selector) ) {
          $this.show();
          filteredIds.push($this.attr("data-id"));
          filtered_items++;
        }
        else {
          $this.hide();
        }
      });

      // Reset filter button w/listner
      $($filterForm).find("input[type='reset']").show().click(function() {
        $filterForm.find("select option").removeAttr('selected');
        filter = {};
        saveFilter();
        updateList();
      });
    }

    // Update the filter status text
    $filterForm.find(".status").text(filtered_items + " av " + total_items + " boenden visas");
  }

  // Save filter in a cookie so we can set it when the user gets back to the list page
  function saveFilter() {
    $.cookie('nursing_homes_filter', JSON.stringify(filter), { path: '/', domain: 'malmo.se' });
  }

  // Set filter select box values on load and perform filtering
  function setFilter() {
    filter = JSON.parse($.cookie('nursing_homes_filter')) || {};
    if (!$.isEmptyObject(filter)) {
      if (!!filter.neighborhood) $("#neighborhood option[value=" + filter.neighborhood + "]").attr("selected", true);
      if (!!filter.category) $("#category option[value=" + filter.category + "]").attr("selected", true);
      if (!!filter.owner_type) $("#owner_type option[value=" + filter.owner_type + "]").attr("selected", true);
      updateList();
    }
  }

  function readFilterForm() {
    filter.neighborhood = $("#neighborhood option:selected").val();
    filter.category = $("#category option:selected").val();
    filter.owner_type = $("#owner_type option:selected").val();
  }

  function resetList() {
    // Remove reset button
    $filterForm.find("input[type='reset']").hide();

    $listItems.filter(":hidden").slideDown();
    filteredIds = [];
    filtered_items = total_items;
  }
});
