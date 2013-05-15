# encoding: utf-8
class EventsController < ApplicationController
  before_filter :authenticate_user!, except: :index
  load_and_authorize_resource
  skip_load_resource only: :create
  respond_to :html, :json

  def index
    respond_with(@events)
  end

  def show
    if @event.can_see?(current_user)
      with_comments(@event)

      @invites = @event.invites
      @members = @event.members

      @can_join = @event.can_join?(current_user)
      @can_unjoin = @event.can_unjoin?(current_user)
      @can_invite = @event.can_invite?(current_user)

      respond_with(@event)
    else
      render :no_show
    end
  end

  def new
    @places = Place.all
    respond_with(@event)
  end

  def create
    @event = current_user.events.new(params[:event])

    if @event.save
      total(1)
      flash[:notice] = 'Дринк добавлен.'
      respond_with(@event)
    else
      flash[:alert] = 'Дринк не добавлен.'
      @places = Place.all
      respond_with(@event, location: new_event_path)
    end
  end

  def edit
    @places = Place.all
    respond_with(@event)
  end

  def update
    params[:event][:begin_at] = Time.parse(params[:event][:begin_at]).getutc
    params[:event][:end_at] = Time.parse(params[:event][:end_at]).getutc

    if @event.update_attributes(params[:event])
      flash[:notice] = 'Информация о дринке обновлена.'
      respond_with(@event)
    else
      flash[:alert] = 'Информация о дринке не обновлена.'
      @places = Place.all
      respond_with(@event, location: edit_event_path)
    end
  end

  def destroy
    total(-1) if @event.destroy
    flash[:notice] = 'Дринк удален.'
    respond_with(@event)
  end

  def join
    if @event.can_join?(current_user)
      if @event.join!(current_user)
        flash[:notice] = 'Отлично, вы с нами.'
      else
        flash[:alert] = 'Не получилось присоединиться.'
      end
    else
      flash[:alert] = 'Вы не можете присоединиться.'
    end
    redirect_to event_path(@event)
  end

  def unjoin
    if @event.can_unjoin?(current_user)
      if @event.unjoin!(current_user)
        flash[:notice] = 'Возвращайтесь, если передумаете.'
      else
        flash[:alert] = 'Не получилось отказаться от участия.'
      end
    else
      flash[:alert] = 'Вы не можете отказаться.'
    end
    redirect_to event_path(@event)
  end

private

  def total(i)
    @event.user.inc(:total_create_events, i)
    @event.place.inc(:total_events, i)

    country = Country.where(name: @event.place.location.country).first
    city = City.where(name: @event.place.location.city).first
    country.inc(:total_events, i)
    city.inc(:total_events, i)
  end
end