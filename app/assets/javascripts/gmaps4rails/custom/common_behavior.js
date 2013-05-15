function CommonBehavior(this_map) {

  // Center on Dnepropetrovsk if no markers set.
  var center = new google.maps.LatLng(48.464717, 35.04618299999993);
  this_map.setCenter(center);
  this_map.setZoom(12);

  // Buttons.
  Fullscreen(this_map);
}