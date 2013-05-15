# encoding: utf-8
class FriendsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :user
  respond_to :html, :json

  def index
    @accepted = @user.select_friends(true)
    @unaccepted = @user.select_friends(false) if current_user == @user
    respond_with(@accepted, @unaccepted) # [a,a]
  end

  def new
    if current_user.make_friend!(@user)
      flash[:notice] = "Вы предложили #{@user.name} быть вашим другом."
    else
      flash[:alert] = 'Не получилось отправить предложение.'
    end
    redirect_to user_path(@user)
  end

  def edit
    if current_user.accept_friend!(@user)
      flash[:notice] = "Теперь вы и #{@user.name} друзья."
    else
      flash[:alert] = 'Не удалось наладить дружбу.'
    end
    redirect_to user_path(@user)
  end

  def destroy
    if current_user.remove_friend!(@user)
      flash[:notice] = 'Дружба разорвана.'
    else
      flash[:alert] = 'Не получилось разорвать дружбу.'
    end
    redirect_to user_path(@user)
  end
end