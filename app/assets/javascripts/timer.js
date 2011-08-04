$(function() {
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
      if ($("#minutes").text() == "00" && $("#seconds").text() == "00") {
        clearInterval(timer);
      }
    secs--;
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
