$(document).ready(function(){
  var left_arrow_anmation = setInterval(function() {
    $(".arrow_left").animate({left:"100px"}, 500).animate({left:"60px"}, 500);
  }, 2000)
  var right_arrow_anmation = setInterval(function() {
    $(".arrow_right").animate({right:"100px"}, 500).animate({right:"60px"}, 500);
  }, 2000)

  var login_text = "login or register";
  var password_text = "password";

  if ($('#session_email').val("")) {
    $('#session_email').val(login_text).addClass('label');
  };

  $('#session_email').click(function(){
    if ($('#session_email').val() == login_text) {
      $(this).removeClass("label").val("");
    }
  })

  $('#session_form').live('ajax:complete', function(et, e) {
    if (e.status == 401) {
      $('.login_content button').hide();
      $(".password_content").hide().html(e.responseText).slideDown();
      $("#session_password").focus();
    } else {
      window.location = '/articles'
    }
  });

  $('#password_form').live('ajax:complete', function(et, e) {
    //console.log(e);
    if (e.status == 401) {
      $(".password_content").html(e.responseText);
      $("#session_password").focus();
    } else {
      window.location = '/articles'
    }
  });
})
