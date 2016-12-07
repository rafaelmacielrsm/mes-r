$(document).on('turbolinks:load', function() {
  // modal setup
  $('.modal').modal();

  //active form labels which have a input filled
  Materialize.updateTextFields();

  // chosen call product form
  if (typeof no_result_msg !== 'undefined') {
    chosen_setup();
  }


  //refresh modal on refresh queries
  if ( $('.has-modal').length > 0 ) {
    var target = document.querySelector('#table-container');
    changes_observer(target);
  }




//

});

function changes_observer(target) {
  var observer = new MutationObserver(function(){
    $('.modal').modal();
  });
  observer.observe(target, { childList: true, subtree: true });

  return observer;
}
