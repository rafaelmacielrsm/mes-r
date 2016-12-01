var timer;
function submit_search(){
   clearTimeout(timer);
   timer=setTimeout(function validate(){
     $("#search").submit();
   },250);
}
