$(document).ready(function() {
  $('ul.articles > li:nth-child(4n)').addClass("last").after("<div class='clear'></div>");
  $('#new_article').live('ajax:before', function() {
    $(this).hide();
    $(this).parent().append("Loading...");
  }).live('ajax:complete', function() {
    $('#article_link').val("");
    $(this).show();
  });

  $('.cal a').click(function(){
    $(this).parent().parent().children('.active').removeClass("active");
    $(this).parent().addClass("active");
  }).live('ajax:complete', function() {
    $('ul.articles > li:nth-child(4n)').addClass("last").after("<div class='clear'></div>");
  });


  function equalHeight(group) {
    var tallest = 0;
    group.each(function() {
      var thisHeight = $(this).height();
      if(thisHeight > tallest) {
        tallest = thisHeight;
      }
    });
    group.height(tallest);
  };

});
