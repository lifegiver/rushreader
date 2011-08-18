var resizenow = (function() {
  var browserwidth = $(window).width();
  if (browserwidth > 1080) {
    $('ul#articles').children(".clear").remove();
    $('.article').width("20%");
    $('ul#articles > li:nth-child(5n)').after("<div class='clear'></div>");
  } else if (browserwidth <= 768 && browserwidth >= 480) {
    $('ul#articles').children(".clear").remove();
    $('.article').width("50%");
    $('ul#articles > li:nth-child(2n)').after("<div class='clear'></div>");
  } else if (browserwidth <= 480) {
    $('ul#articles').children(".clear").remove();
    $('.article').width("100%");
    $('.article').height("auto");
  } else {
    $('ul#articles').children(".clear").remove();
    $('.article').width("33%");
    $('ul#articles > li:nth-child(3n)').after("<div class='clear'></div>");
  }

});

$(window).resize(function() {
  resizenow();
}).load(function() {
  resizenow();
});
