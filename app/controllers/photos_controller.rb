# encoding: utf-8
class PhotosController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: :create
  respond_to :html, :json

  # skip_before_filter :verify_authenticity_token, only: :create
  def create
    @photo = current_user.photos.new
    @photo.image = params[:file] if params.has_key?(:file)

    @photo.photographic_id = params[:photographic_id]
    @photo.photographic_type = params[:photographic_class]
    @photo.photographic_field = :photos
    @photo.save!

    if params[:photographic_class] == 'Album'
      total(1)

      @size = :normal
      @comment = Comment.new
      respond_to :js
    else
      render nothing: true
    end
  end

  def destroy
    total(-1)
    @photo.destroy
    flash[:notice] = 'Фото удалено.'
    redirect_back
  end

private

  def total(i)
    if @photo.photographic_type == 'Album'
      @photo.photographic.inc(:total_photos, i)
    end
  end
end