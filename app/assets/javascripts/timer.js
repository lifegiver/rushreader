$(function() {
  var secs = $("#fakeSeconds").text();
  var mins = $("#minutes").text();
  var timer = setInterval(function() {
    // if less than a minute remaining
      secs--;
      if (secs == 0) {
        $('.overlay').fadeOut();
        $('.timer').fadeOut();
        clearInterval(timer);
      } else {
        $("#minutes").text(getminutes());
        $("#seconds").text(getseconds());
      }
  }, 1000);

  function getminutes() {
    mins = Math.floor(secs / 60);
    if (mins < 10) return "0" + mins;
    else return mins;
  }
  function getseconds() {
    var thesec = secs-Math.round(mins *60);
    if (thesec < 10) return "0" + thesec;
    else return thesec;
  }
});
