$(function() {
  Gmaps.map.callback = function() {
    var this_map = Gmaps.map.serviceObject;
    CommonBehavior(this_map);

    // Mouse behavior.
    MouseHover(this_map);

    // Buttons.
    Hide(this_map);
    LiveAll(this_map);
    ReadyAll(this_map);
    PlacesAll(this_map);
    
    if (current_user_id != null) {
      MyAll(this_map);
      MyLikes(this_map);
      LiveFriends(this_map);
      ReadyFriends(this_map);
      LiveFoF(this_map);
      ReadyFoF(this_map);
    }
  }
});