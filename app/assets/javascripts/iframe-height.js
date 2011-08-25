//function to fix height of iframe!
var calcHeight = function() {
  var headerDimensions = $('.header').outerHeight()+$(".alert").outerHeight();
  $('#article-iframe').height($(window).height() - headerDimensions);
}

$(window).resize(function() {
  calcHeight();
}).load(function() {
  calcHeight();
});
