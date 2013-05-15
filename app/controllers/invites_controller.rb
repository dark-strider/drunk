# encoding: utf-8
class InvitesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: :create
  respond_to :html, :json

  def show
    respond_with(@invite)
  end

  def new
    select
    respond_with(@invite)
  end

  def create
    params[:invite][:whom_id].shift
    array = params[:invite][:whom_id]
    event_id = params[:invite][:event_id]
    
    if array.any? && !event_id.blank?
      @whom_size = array.size
      @exists_count = 0
      @count = 0

      # mass_create
      array.each do |user_id|
        if Invite.where(user_id: current_user.id, event_id: event_id, whom_id: user_id).exists?
          # Если такой инвайт уже существует.
          @exists_count += 1
        elsif Event.find(event_id).user_id.to_s == user_id
          # Если приглашаемый человек, автор этого эвента.
          @exists_count += 1
        elsif Event.where(member_ids: user_id).find(event_id)
          # Если приглашаемый человек, уже участник этого эвента.
          @exists_count += 1
        else
          # Если все нет, то создаем.
          @invite = current_user.invites.new(params[:invite])
          @invite.event_id = event_id
          @invite.whom_id = user_id
          @count += 1 if @invite.save
        end
      end
      calculate_message
      redirect_to event_path(event_id)
    else
      flash[:alert] = 'Ошибка при отправке приглашения.'
      redirect_back
    end
  end

  def edit
    @events = @invite.event
    @users = @invite.whom
    @whom_id = @invite.whom_id
    @event_id = @invite.event_id
    respond_with(@invite)
  end

  def update
    if @invite.update_attributes(params[:invite])
      flash[:notice] = 'Информация о приглашении обновлена.'
      redirect_back
    else
      flash[:alert] = 'Информация о приглашении не обновлена.'
      @events = @invite.event
      @users = @invite.whom
      @whom_id = @invite.whom_id
      @event_id = @invite.event_id
      respond_with(@invite, location: edit_invite_path)
    end
  end

  def destroy
    @invite.destroy
    flash[:notice] = 'Приглашение удалено.'
    redirect_back
  end

  def accept
    @invite = Invite.find(params[:invite_id])
    @event = Event.find(@invite.event_id)

    if @event.user_id == current_user.id
      flash[:alert] = 'Вы инициатор дринка. Вы не можете принять приглашение.'
    else
      if @invite.accept!(@event, current_user)
        flash[:notice] = 'Приглашение принято.'
      else
        flash[:alert] = 'Приглашение не принято.'
      end
    end
    redirect_to event_path(@event)
  end

  def refuse
    @invite = Invite.find(params[:invite_id])
    @event = Event.find(@invite.event_id)

    if @event.user_id == current_user.id
      flash[:alert] = 'Вы инициатор дринка. Вы не можете отклонить приглашение.'
    else
      if @invite.refuse!(current_user)
        flash[:notice] = 'Приглашение отклонено.'
      else
        flash[:alert] = 'Приглашение не отклонено.'
      end
    end
    redirect_back
  end

private

  def select
    # events, that can_invite
    select_events

    if @events.any?
      # select users
      @users = User.excludes(id: current_user.id)

      # set selected
      @whom_id = params[:whom] if params[:whom]
      @event_id = params[:event] if params[:event]

      # if came from event, select allowed users (no member, no invited)
      select_allowed_users if @event_id

      # for select2's buttons
      set_friends
    end
  end

  def select_events
    @events = []
    all = current_user.events + current_user.member_of_events
    all.each do |event|
      @events << event if event.can_invite?(current_user)
    end
    @events
  end

  def select_allowed_users
    event = Event.find(@event_id)
    member = []
    invited = []
    
    @users.each do |user|
      member << user if event.members.include?(user)
      invited << user if Invite.where(event_id: @event_id, whom_id: user.id).exists?
    end
    @users = @users - member - invited
  end

  def set_friends
    @current_friends_ids = []
    @current_fof_ids = []
    
    current_user.accepted_friends.each do |f|
      # friends
      @current_friends_ids << f.friend_id
      
      # friends of friends
      fof_user = User.find(f.friend_id)
      if fof_user && fof_user.friends.any?
        fof_user.accepted_friends.each do |fof|
          @current_fof_ids << fof.friend_id
        end
      end
    end
    @current_fof_ids = (@current_friends_ids + @current_fof_ids).uniq
  end

  def calculate_message
    if @whom_size == @count + @exists_count
      if @whom_size == 1
        if @exists_count == 0
          @message = 'Приглашение отправлено.'
        else
          @message = 'Этот пользователь уже был приглашен ранее. Или уже является участником.'
        end
      else
        if @exists_count == 0
          @message = "Приглашения разосланы. Всего: #{@count}."
        else
          if @count == 0
            @message = 'Эти пользователи уже были приглашены ранее.'
          else
            @message = "Приглашения разосланы. Новых приглашений: #{@count}. Уже существовавших приглашений или участников: #{@exists_count}."
          end
        end
      end
      flash[:notice] = @message
    else
      if @whom_size == 1
        @message = 'Приглашение не отправлено.'
      else
        if @exists_count == 0
          @message = "Не все приглашения разосланы. Успешно только: #{@count}."
        else
          @expected = @whom_size - @exists_count
          @message = "Не все приглашения разосланы. Успешно только #{@count} из #{@expected}. Уже существующих: #{@exists_count}."
        end
      end
      flash[:alert] = @message
    end
  end
end