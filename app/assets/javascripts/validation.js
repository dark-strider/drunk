// validation simple_comment
//
function validate_simple_comment(thisform) {
  var size = $(thisform).find('#comment_content').val().length;
  if (size != 0) {
    if (size <= 200) {
      return true;
    } 
    else {
      alert('Длина комментария не должна превышать 200 символов. У вас: '+ size +'.');
      return false;
    }
  }
  else {
    $(thisform).find('#comment_content').attr('placeholder', 'Сначала введите комментарий ...').blur();
    return false;
  }
}