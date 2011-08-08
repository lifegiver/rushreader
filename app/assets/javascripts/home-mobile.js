$(document).ready(function() {

  $(".login-box a").click(function(){
    var toLoad = $(this).attr('href');
    $('#loader').animate({left: $('#loader').outerWidth()},350,loadContent);

    function loadContent() {
      $('#loader').load(toLoad, showNewContent);
    }

    function showNewContent() {
      $('#loader').animate({left: 0},350);
    }

    return false;
  })

});
