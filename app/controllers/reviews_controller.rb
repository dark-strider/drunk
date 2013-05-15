# encoding: utf-8
class ReviewsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :place
  load_and_authorize_resource :review, through: :place
  skip_load_resource only: :create
  respond_to :html, :json

  def index
    @reviews = @reviews.desc(:created_at)
    respond_with(@reviews)
  end

  def show
    with_comments(@review)
    with_photos(@review)
    respond_with(@review)
  end

  def new
    respond_with(@review)
  end

  def create
    @review = current_user.reviews.new(params[:review])
    @review.id = params[:review][:id] if params[:review][:id]
    @review.place = @place

    if @review.save
      total(1)
      flash[:notice] = 'Отзыв добавлен.'
      respond_with(@place, @review)
    else
      flash[:alert] = 'Отзыв не добавлен.'
      respond_with(@review, location: new_place_review_path)
    end
  end

  def edit
    respond_with(@review)
  end

  def update
    if @review.update_attributes(params[:review])
      flash[:notice] = 'Содержание отзыва обновлено.'
      respond_with(@place, @review)
    else
      flash[:alert] = 'Содержание отзыва не обновлено.'
      respond_with(@review, location: edit_place_review_path)
    end
  end

  def destroy
    total(-1) if @review.destroy
    flash[:notice] = 'Отзыв удален.'
    redirect_to place_reviews_path(@place)
  end

private

  def total(i)
    @review.user.inc(:total_reviews, i)
    @review.place.inc(:total_reviews, i)
  end
end