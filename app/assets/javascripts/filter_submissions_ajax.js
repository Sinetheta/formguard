$("#filtered-results").on('click', ' .pagination a', function(event){
  event.preventDefault();
  match = $(this).context.search.match(/[^per_]page=(\d+)/);
  if (match) {
    page = match[1];
  } else {
    page = 1;
  }
  filterSubmissions(buildSearch(page));
});

$("#filter-form").on('submit', function(event){
  event.preventDefault();
  filterSubmissions(buildSearch(1));
});

function filterSubmissions(data){
  $.get({
    url: data.base_action + "/filtered_submissions",
    data: data.search_params,
    success: function(response){
      $("#filtered-results").html(response);
      var path = window.location.pathname;
      var search = window.location.search;
      history.pushState(null, "Formguard", buildSearchString(search, data.search_params));
    }
  })
}

function buildSearch(page) {
  var data = {
    "base_action": $("#filter-form")[0].action,
    "search_params": {
      "q": $("#q")[0].value,
      "page": page,
      "per_page": 25
    }
  }

  var perPageRegex = /per_page=[^&]*/;

  if (perPageRegex.test(window.location.search)){
    data.search_params.per_page = window.location.search.match(perPageRegex)[0].split("=")[1]
  }
  return data;
}

function buildSearchString(original_path, search_data) {
  var new_path = original_path.replace(/^[\?|&]*/, "");

  for (var datum_key in search_data) {
    var regex = new RegExp(datum_key + "=[^&]*");
    var replacement = datum_key + "=" + search_data[datum_key];

    if (regex.test(original_path)){
      new_path = new_path.replace(regex, replacement);
    } else {
      new_path += "&" + replacement;
    }

  }
  return "?" + new_path;
}
