$(function() {
  var start_box = $('#begin');
  var end_box = $('#end');
  var default_start = start_box.val();
  var default_end = end_box.val();
  var today = new Date();

  start_box.datetimepicker({
    changeYear: true,
    changeMonth: true,
    dateFormat: 'yy-mm-dd',
    timeFormat: 'hh:mm',
    yearRange: '-0:+1',
    hourGrid: 4,
    minuteGrid: 10,
    minDate: today,

    onClose: function(dateText, inst) {
      if (default_end != '') {
        // Нахожу Unixtime для только что указанной даты и той что была в другой форме.
        var unix_start = Date.parse(dateText);
        // Проверяю не менялась ли уже дата в другой форме, в зависимости от этого выбираю.
        var test_end = end_box.val();
        if (test_end != '') {
          var unix_end = Date.parse(test_end);
        } else {
          end_box.val(dateText);
          var unix_end = Date.parse(default_end);
        }
        // Сравниваю их. Если начало идет после окончания, меняю окончание.
        if (unix_start > unix_end)
          end_box.val(dateText);
      } else {
        end_box.val(dateText);
        default_start = dateText;
        default_end = dateText;
      }
    }
  });

  end_box.datetimepicker({
    changeYear: true,
    changeMonth: true,
    dateFormat: 'yy-mm-dd',
    timeFormat: 'hh:mm',
    yearRange: '-0:+1',
    hourGrid: 4,
    minuteGrid: 10,
    minDate: today,

    onClose: function(dateText, inst) {
      if (default_start != '') {
        // Нахожу Unixtime для только что указанной даты и той что была в другой форме.
        var unix_end = Date.parse(dateText);
        // Проверяю не менялась ли уже дата в другой форме, в зависимости от этого выбираю.
        var test_start = start_box.val();
        if (test_start != '') {
          var unix_start = Date.parse(test_start);
        } else {
          start_box.val(dateText);
          var unix_start = Date.parse(default_start);
        }
        // Сравниваю их. Если начало идет после окончания, меняю начало.
        if (unix_start > unix_end)
          start_box.val(dateText);
      } else {
        start_box.val(dateText);
        default_start = dateText;
        default_end = dateText;
      }
    }
  });
});

$(function() {
  $('#user_birthday').datepicker({
    changeYear: true,
    changeMonth: true,
    dateFormat: 'yy-mm-dd',
    yearRange: '1940:2000',
  });
});