# encoding: utf-8
class MenusController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :place
  load_and_authorize_resource :menu, through: :place
  skip_load_resource only: :create # (?)
  respond_to :html, :json

  def index
    @menus = @menus.desc(:created_at)
    respond_with(@menus)
  end

  def new
    respond_with(@menu)
  end

  def create
    @menu = current_user.menus.new(params[:menu])
    @menu.place = @place

    if @menu.save
      flash[:notice] = 'Продукт добавлен.'
      redirect_to place_menus_path(@place)
    else
      flash[:alert] = 'Продукт не добавлен.'
      respond_with(@menu, location: new_place_menu_path)
    end
  end

  def edit
    respond_with(@menu)
  end

  def update
    if @menu.update_attributes(params[:menu])
      flash[:notice] = 'Продукт обновлен.'
      redirect_to place_menus_path(@place)
    else
      flash[:alert] = 'Продукт не обновлен.'
      respond_with(@menu, location: edit_place_menu_path)
    end
  end

  def destroy
    @menu.destroy
    flash[:notice] = 'Продукт удален.'
    redirect_to place_menus_path(@place)
  end
end