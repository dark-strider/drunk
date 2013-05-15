# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, except: :index
  load_and_authorize_resource
  respond_to :html, :json

  def index
    @users = @users.desc(:created_at)
    respond_with(@users)
  end

  def show
    save_path
    respond_with(@user)
  end

  def events
    @events = @user.events.desc(:created_at)
    @member_of_events = @user.member_of_events
    @received_invites = @user.received_invites
    save_path
    respond_with(@events)
  end
end