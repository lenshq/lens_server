$(document).on("ajax:success", "#new_subscriber", function(e, data, status, xhr) {
  $(".has-error").removeClass("has-error");
  $(".help-block").html("");
  $("#subscriber_new_title_js").html("Ok, got it!").addClass("success");
});

$(document).on("ajax:error", "#new_subscriber", function(e, data, status, xhr) {
  errors = data.responseJSON;

  $.each(errors, function(key, message) {
    parent = $("#subscriber_" + key).parent();
    parent.addClass("has-error");
    parent.find(".help-block").html(message.join(", "));
  });
});
