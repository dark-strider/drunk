// Common in form_for
// 
$('#event_place_id, #event_condition, #event_visibility, #event_joinable, #event_inviteable, #event_maximum, #country, #city, #news_category, #place_opened_in, #review_impression').select2({
  width: '270px'
});

// Place form_for
//
$('#place_place_type_ids').select2({
  width: '270px',
  placeholder: 'Укажите тип заведения ...'
});

// Invite form_for
//
$('#invite_event_id').select2({
  width: '270px',
  allowClear: true,
  placeholder: 'Укажите дринк ...'
});

$('#invite_whom_id').select2({
  formatResult: inviteFormat,
  formatSelection: inviteFormat,
  width: '384px',
  placeholder: 'Укажите кому отправить ...',
  escapeMarkup: function(m) { return m; }
});

$('#set_friends').click(function () {
  $('#invite_whom_id').val(current_friends_ids).trigger('change');
});

$('#set_fof').click(function () {
  $('#invite_whom_id').val(current_fof_ids).trigger('change');
});


//- Search dropdown -//
// 
// Users
$('#search_users').select2({
  placeholder: 'Найти пользователя ...',
  width: '295px',
  minimumInputLength: 0,
  ajax: {
    url: '/searches/users',
    dataType: 'json',
    quietMillis: 200,
    data: function (term, page) {
      return {
        q: term,
        page_limit: 10,
        page: page
      };
    },
    results: function (data, page) {
      var more = (page * 10) < data.total;
      return { results: data, more: more };
    }
  },
  formatResult: usersFormatR,
  formatSelection: formatS,
  dropdownCssClass: 'users_select_format'
});

// Places
$('#search_places').select2({
  placeholder: 'Найти заведение ...',
  width: '295px',
  minimumInputLength: 0,
  ajax: {
    url: '/searches/places',
    dataType: 'json',
    quietMillis: 200,
    data: function (term, page) {
      return {
        q: term,
        page_limit: 3,
        page: page
      };
    },
    results: function (data, page) {
      var more = (page * 3) < data.total;
      return { results: data, more: more };
    }
  },
  formatResult: placesFormatR,
  formatSelection: formatS,
  dropdownCssClass: 'places_select_format'
});

// Events
$('#search_events').select2({
  placeholder: 'Найти событие ...',
  width: '337px',
  minimumInputLength: 0,
  ajax: {
    url: '/searches/events',
    dataType: 'json',
    quietMillis: 200,
    data: function (term, page) {
      return {
        q: term,
        page_limit: 10,
        page: page
      };
    },
    results: function (data, page) {
      var more = (page * 10) < data.total;
      return { results: data, more: more };
    }
  },
  formatResult: eventsFormatR,
  formatSelection: formatS,
  dropdownCssClass: 'events_select_format'
});

// Redirect_to
//
$('#search_places').on('change', function(id) {
  window.location.href = '/places/'+ id.val;
});

$('#search_users').on('change', function(id) {
  window.location.href = '/users/'+ id.val;
});

$('#search_events').on('change', function(id) {
  window.location.href = '/drinks/'+ id.val;
});

// Common functions
//
function UrlExists(url) {
  var http = new XMLHttpRequest();
  http.open('GET', url, false);
  http.send();
  return (http.status != 404);
}

function SendUrl(user) {
  var send_url = '';
  if (user.id != null) {
    var url = '/uploads/avatar/' + user.id.toLowerCase() + '/small_avatar.jpg';
  }
  else {
    var url = '/uploads/avatar/' + user.toLowerCase() + '/small_avatar.jpg';
  }

  if (UrlExists(url) == true) {
    send_url = url;
  } else {
    send_url = '/assets/avatar/small_avatar.jpg';
  }
  return send_url;
}


// Dropdown formats output -//
//
// Invite
function inviteFormat(user) {
  send_url = SendUrl(user);
  return "<img class='select_avatar' src='" + send_url + "'> " + user.text;
}

// Users
function usersFormatR(user) {
  send_url = SendUrl(user);
  var markup = "<div class='select'>";
  markup += "<img src="+ send_url +">";
  markup += "<div class='select_body'>";
  markup += "<div class='select_name'>"+ user.name +"</div>";
  markup += "<div class='select_address'>";
  
  if (user.city != '' && user.city != null)
    markup += user.city;
  if (user.city != '' && user.city != null && user.country != '' && user.country != null)
    markup += ", ";
  if (user.country != '' && user.country != null)
    markup += user.country;
  markup += "</div></div></div>";   
  return markup;
}

// Places
function placesFormatR(place) {
  var markup = "<div class='select'>";
  markup += "<div class='select_rating'>"+ place.rating +"</div>";
  markup += "<div class='select_body'>";
  markup += "<div class='select_name'>"+ place.name +"</div>";
  markup += "<div class='select_address'>"+ place.street +"<br>"+ place.city +", "+ place.country+"</div>";
  markup += "</div></div>";   
  return markup;
}

// Events
function eventsFormatR(event) {
  send_url = SendUrl(event.user_id);
  var markup = "<div class='select'>";

  markup += "<div class='select_picture'>";
  markup += "<img src="+ send_url +">";
  markup += "<div class='select_members'>"+ event.members +"ч.</div></div>";

  markup += "<div class='select_body'>";
  markup += "<div class='select_name'>"+ event.name +"</div>";
  markup += "<div class='select_place'>"+ event.place +"</div>";
  
  markup += "<div class='select_date'>";
  if (event.condition == 'live') {
    markup += "<span class='select_live'>LIVE</span> - окончание в "+ event.end_at;
  }
  else {
    markup += "<span class='select_status'>"+ event.status +"</span>";
    markup += " - "+ event.begin_at;
  }
  markup += "</div>";

  markup += "</div></div>";
  return markup;
}

// Common formatS
function formatS(data) {
  return data.name;
}
