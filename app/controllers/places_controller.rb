# encoding: utf-8
class PlacesController < ApplicationController
  before_filter :authenticate_user!, except: :index
  load_and_authorize_resource
  skip_load_resource only: :create
  before_filter :coordinates, only: [:create, :update]
  respond_to :html, :json

  def index
    @places = @places.desc(:created_at)
    respond_with(@places)
  end

  def show
    @reviews = @place.reviews.desc(:created_at).limit(5)
    save_path
    respond_with(@place)
  end

  def new
    select
    respond_with(@marker)
  end

  def create
    @place = current_user.places.new(params[:place])

    if @place.save
      total(1)
      flash[:notice] = 'Заведение добавлено.'
      respond_with(@place)
    else
      select
      flash[:alert] = 'Заведение не добавлено.'
      respond_with(@place, location: new_place_path)
    end
  end

  def edit
    select
    respond_with(@marker)
  end

  def update
    if @place.update_attributes(params[:place])
      flash[:notice] = 'Информация о заведении обновлена.'
      respond_with(@place)
    else
      select
      flash[:alert] = 'Информация о заведении не обновлена.'
      respond_with(@place, location: edit_place_path)
    end
  end

  def destroy
    total(-1) if @place.destroy
    flash[:notice] = 'Заведение удалено.'
    respond_with(@place)
  end

  def events
    @events = @place.events.desc(:created_at)
    respond_with(@events)
  end

private

  def coordinates
    # Полученную строку с координатами преобразовываем в массив из float.
    # Для корректной записи массива Coordinates.
    coordinates = params[:place][:location_attributes][:coordinates].gsub('[','').gsub(']','').gsub(' ','')
    if coordinates != ''
      params[:place][:location_attributes][:coordinates] = coordinates.split(',').map{ |s| s.to_f }
    end
  end

  def select
    @place_types = PlaceType.all
    @countries = Country.all
    @cities = City.all

    if action_name == 'new'
      @place.location ||= Location.new
      @marker ||= []
    else
      @marker = @place.to_gmaps4rails do |place, marker|
        marker.picture({ picture: '/assets/gmaps4rails/place.png', width: 32, height: 37 })
      end
    end
  end

  def total(i)
    country = Country.where(name: @place.location.country).first
    city = City.where(name: @place.location.city).first
    country.inc(:total_places, i)
    city.inc(:total_places, i)
  end
end