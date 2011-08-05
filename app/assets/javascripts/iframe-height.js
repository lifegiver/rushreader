//function to fix height of iframe!
var calcHeight = function() {
  var headerDimensions = $('.header').height()+1;
  $('#article-iframe').height($(window).height() - headerDimensions);
}

$(window).resize(function() {
  calcHeight();
}).load(function() {
  calcHeight();
});
