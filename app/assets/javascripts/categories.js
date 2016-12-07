var timer;
function submit_search(){
   clearTimeout(timer);
   timer=setTimeout(function(){
     $("#search").submit();
   },250);
}
