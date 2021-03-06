$(document).ready(function() {
  //$('ul#articles > li:nth-child(4n)').addClass("last").after("<div class='clear'></div>");
  $('#new_article').live('ajax:before', function() {
    $(this).hide();
    $(this).parent().append("Loading...");
  }).live('ajax:complete', function() {
    $('#article_link').val("");
    $(this).show();
  });

  $('.article a').click(function(){
    $(this).parent().parent().parent().addClass("article-read");
  });

  //Add link here
  if ($('#article_link').val("")) {
    $('#article_link').val("Add link here...").addClass('label');
  };

  var mouse_inside_link = false;
  $('#article_link').hover(function() {
    mouse_inside_link = true;
  }, function() {
    mouse_inside_link = false;
  });

  $("body").mouseup(function(){
    if(! mouse_inside_link) {
      $('#article_link').animate({
        width: '115'
      }, 500, function() {
        // Animation complete.
        $('#new_article button').hide();
        $('#article_link').addClass("label");
        if ($(this).val("")) $(this).val("Add link here...");
    });
    };
  });

  $('#article_link').click(function() {
    if ($(this).val("Add link here...")) {
      $(this).val("").removeClass("label")
    }
    $(this).animate({
      width: '250'
    }, 500, function() {
      // Animation complete.
      $('#new_article button').show(100);

    });
  });

  // Notice
  $('#notice').delay(10000).fadeOut(1000);
});
