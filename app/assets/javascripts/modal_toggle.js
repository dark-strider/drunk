// modal
//
$('#license').modal({
  show: false,
  keyboard: false,
  backdrop: 'static'
})

$('.modal_comment').click(function() {
  $('#modal_container').draggable().modal({
    backdrop: 'static',
    keyboard: true
  });
  return false;
});


// toggle
//
$('.toggle_answer').click(function() {
  $(this).parents('.parent').children('.answered_to').slideToggle(0);
  return false;
});

$('#toggle_uploader_comment').click(function() {
  $('#uploader_comment').slideToggle(0);
  return false;
});

$('#toggle_uploader_review').click(function() {
  $('#uploader_review').slideToggle(0);
  return false;
});

$('#toggle_uploader_album').click(function() {
  $('#uploader_album').slideToggle(0);
  return false;
});


// toggle is_active for News
//
$(window).load(function() {
  var category = $('#news_category').val();
  if (category === 'Акция') {
    $('#is_active').show();
  }
  else {
    $('#is_active').hide();
  }
});

$('#news_category').change(function() {
  var category = $('#news_category').val();
  if (category === 'Акция') {
    $('#is_active').show();
  }
  else {
    $('#is_active').hide();
  }
});
