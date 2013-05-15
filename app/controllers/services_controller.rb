# encoding: utf-8
class ServicesController < ApplicationController
  before_filter :authenticate_user!, only: :destroy
  load_and_authorize_resource

  def destroy
    flash[:notice] = "#{@service.provider.capitalize} удален из вашего аккаунта."
    @service.destroy
    redirect_to user_path(current_user)
  end
end