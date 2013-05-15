# encoding: utf-8
class NewsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :place
  load_and_authorize_resource :news, through: :place
  skip_load_resource only: :create
  respond_to :html, :json

  def index
    @news = @news.desc(:created_at)
    respond_with(@news)
  end

  def show
    with_comments(@news)
    respond_with(@news)
  end

  def new
    respond_with(@news)
  end

  def create
    @news = current_user.news.new(params[:news])
    @news.place = @place
    @news.is_special = true if params[:news][:category] == News::CATEGORIES.last

    if @news.save
      total(1)
      flash[:notice] = 'Новость добавлена.'
      respond_with(@place, @news)
    else
      flash[:alert] = 'Новость не добавлена.'
      respond_with(@news, location: new_place_news_path)
    end
  end

  def edit
    respond_with(@news)
  end

  def update
    if @news.category != params[:news][:category]
      if params[:news][:category] == News::CATEGORIES.last
        @news.is_special = true
      else
        @news.is_special = false
      end
    end

    if @news.update_attributes(params[:news])
      flash[:notice] = 'Новость обновлена.'
      respond_with(@place, @news)
    else
      flash[:alert] = 'Новость не обновлена.'
      respond_with(@news, location: edit_place_news_path)
    end
  end

  def destroy
    total(-1) if @news.destroy
    flash[:notice] = 'Новость удалена.'
    redirect_to place_news_index_path(@place)
  end

private

  def total(i)
    @news.place.inc(:total_news, i)
  end
end