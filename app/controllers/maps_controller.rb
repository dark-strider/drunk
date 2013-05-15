class MapsController < ApplicationController
  respond_to :json

  def my_all
    respond_with(select_my_events)
  end

  def my_likes
    respond_with(select_my_liked_places)
  end

  def live_friends
    respond_with(select_friends_events(:live))
  end

  def ready_friends
    respond_with(select_friends_events(:ready))
  end

  def live_fof
    respond_with(select_fof_events(:live))
  end

  def ready_fof
    respond_with(select_fof_events(:ready))
  end

  def live_all
    respond_with(select_all_events(:live))
  end

  def ready_all
    respond_with(select_all_events(:ready))
  end

  # def ready_week
  #   # Эвенты в ближайшие 7 дней.
  #   respond_with(select_week_events(:ready))
  # end

  def places_all
    respond_with(select_all_places)
  end

private

  def select_my_events
    # find my events, can_see all by default
    collection = current_user.events + current_user.member_of_events
    # find uniq places
    places = find_uniq_places(collection)
    # for map
    json = create_json(places, collection)
  end

  def select_my_liked_places
    # find places I liked
    places = current_user.like.place_likes
    # find in this places events, that can_see
    collection = []
    places.each do |place|
      place.events.each do |event|
        collection << event if event.can_see?(current_user)
      end
    end
    # for map
    json = create_json(places, collection)
  end

  def select_friends_events(condition)
    # find friends
    friend_ids = []
    current_user.accepted_friends.each do |f|
      friend_ids << f.friend_id
    end
    friends = User.find(friend_ids)

    # find friend's uniq events, that can_see
    collection = find_uniq_events_of_friends(condition, friends)
    # find uniq places
    places = find_uniq_places(collection)
    # for map
    json = create_json(places, collection)
  end

  def select_fof_events(condition)
    # find friends
    friend_ids = []
    current_user.accepted_friends.each do |f|
      friend_ids << f.friend_id
    end

    # find friends of friends
    friends = []
    if friend_ids.any?
      fof_ids = []
      
      friend_ids.each do |id|
        user = User.find(id)
        if user
          user.accepted_friends.each do |ff|
            fof_ids << ff.friend_id if ff.friend_id != current_user.id
          end
        end
      end
      ids = (friend_ids + fof_ids).uniq
      friends = User.find(ids)
    end

    # find fof's uniq events, that can_see
    collection = find_uniq_events_of_friends(condition, friends)
    # find uniq places
    places = find_uniq_places(collection)
    # for map
    json = create_json(places, collection)
  end

private

  def find_uniq_events_of_friends(condition, friends)
    collection = []
    if friends.any?
      all = Event.send(condition)
      all.each do |event|
        friends.each do |friend|
          unless collection.include?(event)
            if event.user == friend || event.members.include?(friend)
              collection << event if event.can_see?(current_user)
            end
          end
        end
      end
    end
    collection
  end
end