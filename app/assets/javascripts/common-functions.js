function set_query() {
  query = document.getElementById('query').value;
}

function add_query_to_params(id_selector){
  var element = "#" + id_selector;
  var href = $(element).find('a').attr('href');
  $(element).find('a').attr('href', href + "?query=" + query);
  return true;
}

function chosen_setup(){
  $(".chosen-select").chosen({width: "100%", no_results_text: no_result_msg});
}
