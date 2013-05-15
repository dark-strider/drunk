# encoding: utf-8
class SearchesController < ApplicationController
  respond_to :json

  # params[:q]
  # params[:page_limit]
  # params[:page]

  # Здесь нужно указывать id так как дефолтом в json пишет _id параметр,
  # который не распознает Select2.
  def places
    regex = /#{params[:q]}/i
    json = Place.where(name: regex).map{ |q| { id: q.id,
                                               name: q.name,
                                               country: q.country,
                                               city: q.city,
                                               street: q.street,
                                               rating: 8.5 }}
    respond_with(json)
  end

  def users
    regex = /#{params[:q]}/i
    json = User.where(name: regex).map{ |q| { id: q.id,
                                              name: q.name,
                                              country: q.country,
                                              city: q.city }}
    respond_with(json)
  end

  def events
    regex = /#{params[:q]}/i
    json = Event.where(name: regex).map{ |q| { id: q.id,
                                               user_id: q.user_id.to_s,
                                               name: q.name,
                                               place: q.place_name,
                                               condition: q.condition,
                                               status: Event::CONDITION[q.condition.to_sym],
                                               begin_at: I18n.localize(q.begin_at.getlocal, format: :no_year),
                                               end_at: I18n.localize(q.end_at.getlocal, format: :time),
                                               members: q.total_members }}
    respond_with(json)
  end
end