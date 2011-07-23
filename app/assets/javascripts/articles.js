$(document).ready(function() {
  $('ul.articles > li:nth-child(4n)').addClass("last");
  $('#new_article').live('ajax:before', function() {
    $(this).hide();
    $(this).parent().append("Loading...");
  }).live('ajax:complete', function() {
    $('#article_link').val("");
    $(this).show();
    $('ul.articles > li:nth-child(4n)').addClass("last");
  });

  $('.cal a').click(function(){
    $(this).parent().parent().children('.active').removeClass("active");
    $(this).parent().addClass("active");
  })
});
