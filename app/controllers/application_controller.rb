class ApplicationController < ActionController::Base
  protect_from_forgery
  # check_authorization unless: :rails_admin_controller?
  # check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: exception.message
  end

private

  # -Redirect-

  def save_path
    session[:return_to] = request.fullpath
  end

  def redirect_back
    redirect_to (session.delete(:return_to) || main_app.root_path)
  end

  def after_sign_up_path_for(user)
    root_path # devise
  end

  # -Polymorphic-

  def with_comments(resource)
    @comment = Comment.new
    @commentable = resource
    @comments = @commentable.comments.desc(:created_at)
    save_path
  end

  def with_simple_comments
    @comment = Comment.new
    save_path
  end

  def with_photos(resource)
    @comment = Comment.new
    @photographic = resource
    @photos = @photographic.photos.desc(:created_at) 
    save_path
  end

  # -Map select-

  def select_all_places
    # find events, that can_see
    collection = []
    all = Event.all
    all.each do |event|
      collection << event if event.can_see?(current_user)
    end
    # find all places
    places = Place.all
    # for map
    json = create_json(places, collection)
  end

  def select_all_events(condition)
    # find events, that can_see
    collection = []
    all = Event.send(condition)
    all.each do |event|
      collection << event if event.can_see?(current_user)
    end
    # find uniq places
    places = find_uniq_places(collection)
    # for map
    json = create_json(places, collection)
  end

  # -Marker-

  def find_uniq_places(collection)
    place_ids = []
    collection.each do |event|
      place_ids << event.place_id unless place_ids.include?(event.place_id)
    end
    Place.find(place_ids)
  end

  def create_json(places, collection)
    json = places.to_gmaps4rails do |place, marker|
      # place's specials
      specials = place.news.where(is_special: true, is_active: true).desc(:created_at)

      # place's events
      live_events = []
      ready_events = []

      collection.each do |event|
        if event.place_id == place.id
          if event.condition == 'live'
            live_events << event
          elsif event.condition == 'ready' || event.condition == 'waiting'
            ready_events << event
          end
        end
      end

      # icon
      icon = find_icon(live_events, ready_events, specials)

      # marker
      marker.infowindow render_to_string(
        partial: '/_forms/infobox',
        locals: { place: place, live_events: live_events, ready_events: ready_events, specials: specials }
      )
      marker.picture({ picture: "/assets/gmaps4rails/#{icon}.png", width: 32, height: 37 })
      marker.sidebar marker_sidebar(place)
    end
    json
  end

  def find_icon(live, ready, special)
    if live.any?
      icon = 'live'
    elsif ready.any?
      icon = 'ready'
    else
      icon = 'place'
    end
    icon = icon + '_special' if special.any?
    icon
  end

  def marker_sidebar(place)
   "<a class='header' href='/places/#{place.id}'>#{place.name}</a><br><span class='content'>#{place.about}</span>"
  end
end