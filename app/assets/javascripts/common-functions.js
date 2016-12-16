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

function dropdown_setup() {
  $('.dropdown-button').dropdown({
    inDuration: 300,
    outDuration: 225,
    constrain_width: false, // Does not change width of dropdown to that of the activator
    hover: true, // Activate on hover
    gutter: 0, // Spacing from edge
    belowOrigin: false, // Displays dropdown below the button
    alignment: 'left' // Displays dropdown with edge aligned to the left of button
  });
}

function datetime_br_setup() {
  $('.datepicker').pickadate({
    selectMonths: true,//Creates a dropdown to control month
    selectYears: 10,//Creates a dropdown of 15 years to control year
    //The title label to use for the month nav buttons
    labelMonthNext: 'Pŕoximo Mês',
    labelMonthPrev: 'Mês Passado',
    //The title label to use for the dropdown selectors
    labelMonthSelect: 'Escolha o Mês',
    labelYearSelect: 'Escolha o Ano',
    //Months and weekdays
    monthsFull: [ 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro' ],
    monthsShort: [ 'Jan', 'Fef', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez' ],
    weekdaysFull: [ 'Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado' ],
    weekdaysShort: [ 'Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab' ],
    //Materialize modified
    weekdaysLetter: [ 'D', 'S', 'T', 'Q', 'Q', 'S', 'S' ],
    //Today and clear
    today: 'Hoje',
    clear: 'Limpar',
    close: 'Fechar',
    //The format to show on the `input` element
    format: 'dd/mm/yyyy'
  });
}
