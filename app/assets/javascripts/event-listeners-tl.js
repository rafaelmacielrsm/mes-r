$(document).on('turbolinks:load', function() {
  // modal setup
  $('.modal').modal();

  //active form labels which have a input filled
  Materialize.updateTextFields();

  // chosen call product form
  if ( $('.chosen-select').length > 0 ) {
    chosen_setup();
  }

  if ( $('.dropdown-button').length > 0 ) {
    $('.dropdown-button').dropdown({hover: true});
  }

  if ( $('.datepicker').length > 0 ) {
    datetime_br_setup();
  }
  // $('.datepicker').pickadate({
  // selectMonths: true, // Creates a dropdown to control month
  // selectYears: 15 // Creates a dropdown of 15 years to control year
  // });

  $('.money').mask('000.000.000.000.000,00', {reverse: true});
});
