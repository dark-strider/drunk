// $(function() {
  $('.map_events_container').hide();
  $('.map_places_container').hide();
  
  $('#toggle_map_events').click(function(){
    if ($('.map_events_container').is(':hidden')) {
      $('.map_events_container').show();
      $('#toggle_map_events').text('Скрыть карту');
 
      if (Gmaps.map.serviceObject == null) {
        $.getJSON('/maps/live_all', function(json){
          Gmaps.loadMaps();
          Gmaps.map.addMarkers(json);
          MouseHover(Gmaps.map.serviceObject);
        });
      }
    }
    else {
      $('#toggle_map_events').text('Показать на карте');
      $('.map_events_container').hide();
    }
  });

  $('#toggle_map_places').click(function(){
    if ($('.map_places_container').is(':hidden')) {
      $('.map_places_container').show();
      $('#toggle_map_places').text('Скрыть карту');
 
      if (Gmaps.map.serviceObject == null) {
        $.getJSON('/maps/places_all', function(json){
          Gmaps.loadMaps();
          Gmaps.map.addMarkers(json);
          MouseHover(Gmaps.map.serviceObject);
        });
      }
    }
    else {
      $('#toggle_map_places').text('Показать на карте');
      $('.map_places_container').hide();
    }
  });
// });