var resizenow = (function() {
  var browserwidth = $(window).width();
  if (browserwidth > 1080) {
    $('.article').width("20%");
    $('.article').height("80px");
  } else if (browserwidth <= 768 && browserwidth >= 480) {
    $('.article').width("50%");
    $('.article').height("50px");
  } else if (browserwidth <= 480) {
    $('.article').width("100%");
    $('.article').height("50px");
  } else {
    $('.article').width("33%");
    $('.article').height("80px");
  }

});

$(window).resize(function() {
  resizenow();
}).load(function() {
  resizenow();
});
