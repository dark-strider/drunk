# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: :create
  before_filter :load_user
  respond_to :html, :json

  def index
    if current_user == @user
      @messages = current_user.messages + current_user.received_messages
      @messages = @messages.sort_by{ |m| m.created_at }.reverse
      respond_with(@messages)
    else
      flash[:alert] = 'У вас нет доступа к чужим сообщениям.!'
      redirect_to user_messages_path(current_user)
    end
  end

  def show
    @from = User.find(@message.user_id).name
    @to = User.find(@message.whom_id).name
    respond_with(@message)
  end

  def new
    respond_with(@message)
  end

  def create
    @message = current_user.messages.new(params[:message])
    @message.whom = @user
    total(1)

    if @message.save
      flash[:notice] = 'Сообщение отправленно.'
      respond_with(current_user, @message)
    else
      flash[:alert] = 'Сообщение не отправленно.'
      respond_with(@message, location: new_user_message_path)
    end
  end

  def edit
    respond_with(@message)
  end

  def update
    if @message.update_attributes(params[:message])
      flash[:notice] = 'Сообщение обновлено.'
      respond_with(current_user, @message)
    else
      flash[:alert] = 'Сообщение не обновлено.'
      respond_with(@message, location: edit_user_message_path)
    end
  end

  def destroy
    total(-1)
    @message.destroy
    flash[:notice] = 'Сообщение удалено.'
    redirect_to user_messages_path(current_user)
  end

private

  def load_user
    @user = User.find(params[:user_id])
  end

  def total(i)
    @message.user.inc(:total_create_messages, i)
    @message.whom.inc(:total_received_messages, i)
  end
end