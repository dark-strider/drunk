function MouseHover(this_map) {
  var opened = null;
  $.each(Gmaps.map.markers, function(i, marker) {

    // Open infobox by mouse over.
    google.maps.event.addListener(marker.serviceObject, 'mouseover', function() {
      if (marker.infowindow != opened)
        marker.infowindow.open(Gmaps.map.serviceObject, marker.serviceObject);
    });

    // Set 'opened' infobox.
    google.maps.event.addListener(marker.serviceObject, 'click', function() {  
      if (marker.infowindow != opened) {
        marker.infowindow.open(Gmaps.map.serviceObject, marker.serviceObject);
        opened = marker.infowindow;
        // marker.serviceObject.setIcon('/assets/gmaps4rails/opened.png')
      }
    });

    // Close infobox by mouse out.
    google.maps.event.addListener(marker.serviceObject, 'mouseout', function() {
      if (marker.infowindow != opened)
        marker.infowindow.close();
    });

    // Close 'opened' infobox by click on map.
    google.maps.event.addListener(Gmaps.map.serviceObject, 'click', function() {
      opened = null;
      marker.infowindow.close();
    });

    // Disable map Dragging and Scrolling when cursor enters infoBox div
    $(document.body).on('mouseenter', '.infobox', function(){
      this_map.setOptions({ draggable:false, scrollwheel:false });
    });

    $(document.body).on('mouseleave', '.infobox', function(){
      this_map.setOptions({ draggable:true, scrollwheel:true });
    });
  });
}