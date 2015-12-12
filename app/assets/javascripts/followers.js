$(document).on('ajax:success', '#new_follower', function(e, data, status, xhr) {
  $('#follower_new_title_js').html("Ok, got it!").addClass('success');
});

$(document).on('ajax:error', '#new_follower', function(e, data, status, xhr) {
  errors = data.responseJSON;

  $.each(errors, function(key, message) {
    parent = $("#follower_" + key).parent()
    parent.addClass('has-error');
    parent.find('.help-block').html(message.join(', '));
  });
});
