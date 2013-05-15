function Fullscreen(map) {
  var button = document.createElement('fullscreen');
  var width = $('#map').css('width');
  var height = $('#map').css('height');
  var new_width = width;
  var full_title = 'Развернуть на весь экран';
  var full_html = 'Развернуть';
  // var center = new google.maps.LatLng(48.464717, 35.04618299999993);
  button.index = 1;
  button.title = full_title;
  button.innerHTML = full_html;
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(button);

  google.maps.event.addDomListener(button, 'click', function() {
    if (width == new_width) {
      button.title = 'Свернуть до исходного размера';
      button.innerHTML = 'Свернуть';

      $('#map').css('position', 'fixed').
        css('top', 0).
        css('left', 0).
        css('width', '100%').
        css('height', '100%');
      google.maps.event.trigger(map, 'resize');
      new_width = $('#map').css('width');
      // map.setCenter(center);
      return false;
    }
    else {
      button.title = full_title;
      button.innerHTML = full_html;

      $('#map').css('position', 'relative').
        css('top', 0).
        css('width', width).
        css('height', height);
      google.maps.event.trigger(map, 'resize');
      new_width = $('#map').css('width');
      // map.setCenter(center);
      return false;
    }
  });
}

function Hide(map) {
  var button = document.createElement('hide');
  var full_title = 'Скрыть всё кроме открытого окна';
  var full_html = 'Скрыть';
  button.index = 1;
  button.title = full_title;
  button.innerHTML = full_html;
  map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(button);
  
  google.maps.event.addDomListener(button, 'click', function() {
    if (button.innerHTML == full_html) {
      button.title = 'Показать все маркеры';
      button.innerHTML = 'Показать';
      Gmaps.map.hideMarkers();
    }
    else {
      button.title = full_title;
      button.innerHTML = full_html;
      Gmaps.map.showMarkers();
    }
  });
}

function MyAll(map) {
  var button = document.createElement('my');
  button.index = 1;
  button.title = 'Посмотреть все дринки на которые я пойду';
  button.innerHTML = 'Мои дринки';
  map.controls[google.maps.ControlPosition.RIGHT_TOP].push(button);
  GetMarkers(button, 'my_all');
}

function MyLikes(map) {
  var button = document.createElement('my_likes');
  button.index = 2;
  button.title = 'Посмотреть мои любимые места';
  button.innerHTML = 'Мне нравится';
  map.controls[google.maps.ControlPosition.RIGHT_TOP].push(button);
  GetMarkers(button, 'my_likes');
}

function LiveFriends(map) {
  var button = document.createElement('live_friends');
  button.index = 1;
  button.title = 'Показать все текущие дринки моих друзей';
  button.innerHTML = 'Друзья';
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(button);
  GetMarkers(button, 'live_friends');
}

function ReadyFriends(map) {
  var button = document.createElement('ready_friends');
  button.index = 2;
  button.title = 'Показать все ближайшие дринки моих друзей';
  button.innerHTML = 'Друзья';
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(button);
  GetMarkers(button, 'ready_friends');
}


function LiveFoF(map) {
  var button = document.createElement('live_fof');
  button.index = 1;
  button.title = 'Показать все текущие дринки друзей и их друзей';
  button.innerHTML = 'и их друзья';
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(button);
  GetMarkers(button, 'live_fof');
}

function ReadyFoF(map) {
  var button = document.createElement('ready_fof');
  button.index = 2;
  button.title = 'Показать все ближайшие дринки друзей и их друзей';
  button.innerHTML = 'и их друзья'; // 'Друзья друзей'
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(button);
  GetMarkers(button, 'ready_fof');
}

function LiveAll(map) {
  var button = document.createElement('live_all');
  button.index = 1;
  button.title = 'Показать все текущие дринки в городе';
  button.innerHTML = 'Сейчас';
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(button);
  GetMarkers(button, 'live_all');
}

function ReadyAll(map) {
  var button = document.createElement('ready_all');
  button.index = 2;
  button.title = 'Показать все ближайшие дринки в городе';
  button.innerHTML = 'Скоро';
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(button);
  GetMarkers(button, 'ready_all');
}

function PlacesAll(map) {
  var button = document.createElement('places_all');
  button.index = 0;
  button.title = 'Показать все заведения в городе';
  button.innerHTML = 'Все места';
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(button);
  GetMarkers(button, 'places_all');
}


function GetMarkers(button, query) {
  google.maps.event.addDomListener(button, 'click', function() {
    InfoWindowClose();
    $.getJSON('/maps/'+query, function(json){
      Gmaps.map.replaceMarkers(json);
      MouseHover();
    });
  });
}

function InfoWindowClose() {
  if (Gmaps.map.visibleInfoWindow != null)
    Gmaps.map.visibleInfoWindow.close();
}