//function to fix height of iframe!
var calcHeight = function() {
  var headerDimensions = $('.header').height()+1;
  $('#article-iframe').height($(window).height() - headerDimensions);
}

$(document).ready(function() {
  calcHeight();

  $('ul#articles > li:nth-child(4n)').addClass("last").after("<div class='clear'></div>");
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

  $('.cal a').click(function(){
    $(this).parent().parent().children('.active').removeClass("active");
    $(this).parent().addClass("active");
  }).live('ajax:complete', function() {
    $('ul#articles > li:nth-child(4n)').addClass("last").after("<div class='clear'></div>");
  });

  // how many minutes
  var mins = $("#minutes").text();
  var secs = mins * 60;
  var timer = setInterval(function() {
    // if less than a minute remaining
    if (secs < 59) {
      $("#seconds").text(secs);
    } else {
      $("#minutes").text(getminutes());
      $("#seconds").text(getseconds());
    }
    secs--;
  }, 1000);

  function getminutes() {
    mins = Math.floor(secs / 60);
    if (mins < 10) return "0" + mins;
    else return mins;
  }
  function getseconds() {
    thesec = secs-Math.round(mins *60);
    if (thesec < 10) return "0" + thesec;
    else return thesec;
  }

});

$(window).resize(function() {
  calcHeight();
}).load(function() {
  calcHeight();
});
