# encoding: utf-8
class AlbumsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: [:index, :new, :create]
  before_filter :load_albumable
  respond_to :html, :json

  def index
    @albums = @albumable.albums.desc(:created_at)
    @wall_preview = select_wall_preview

    respond_with(@albums)
  end

  def show
    with_photos(@album)
    respond_with(@album)
  end

  def new
    @album = @albumable.albums.new
    respond_with(@album)
  end

  def create
    @album = @albumable.albums.new(params[:album])
    @album.user = current_user

    if @album.save
      total(1)
      flash[:notice] = 'Альбом добавлен.'
      respond_with(@albumable, @album)
    else
      flash[:alert] = 'Альбом не добавлен.'
      render :new
    end
  end

  def edit
    respond_with(@album)
  end

  def update
    if @album.update_attributes(params[:album])
      flash[:notice] = 'Альбом обновлен.'
      respond_with(@albumable, @album)
    else
      flash[:alert] = 'Альбом не обновлен.'
      render :edit
    end
  end

  def destroy
    total(-1) if @album.destroy
    flash[:notice] = 'Альбом удален.'
    respond_with(@albumable, @album)
  end

  def wall
    with_simple_comments

    @comments_photos = []
    @reviews_photos = []
    @events_albums_photos = []
    @places_albums_photos = []
    @user_photos = []

    if @albumable.class.to_s == 'Event'
      @albumable.comments.each do |comment|
        @comments_photos += comment.photos
      end
      @comments_photos = @comments_photos.sort_by{ |p| p.created_at }.reverse
      respond_with(@comments_photos)
    
    else
      @albumable.reviews.each do |review|
        @reviews_photos += review.photos

        review.comments.each do |comment|
          @comments_photos += comment.photos
        end
      end
      
      if @albumable.class.to_s == 'User'
        # @events_albums_photos = []
        # @places_albums_photos = []
        
        @user_photos = @albumable.photos.sort_by{ |p| p.created_at }.reverse
        respond_with(@user_photos)
      else
        @reviews_photos = @reviews_photos.sort_by{ |p| p.created_at }.reverse
        @comments_photos = @comments_photos.sort_by{ |p| p.created_at }.reverse
        respond_with(@reviews_photos + @comments_photos)
      end
    end
  end

private

  def load_albumable
    klass = [User, Event, Place].detect { |c| params["#{c.name.underscore}_id"] }
    @albumable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def total(i)
    @albumable.inc(:total_albums, i)
  end

  def select_wall_preview

    if @albumable.class.to_s == 'Event'
      # comments
      @albumable.comments.reverse_each do |comment|
        if comment.photos.any?
          @preview = comment.photos.last
          break
        end
      end
      @preview
    
    elsif @albumable.class.to_s == 'Place'
      # reviews
      @albumable.reviews.reverse_each do |review|
        if review.photos.any?
          @review_preview = review.photos.last
          break
        end
      end
      
      # review comments
      @albumable.reviews.reverse_each do |review|
        review.comments.reverse_each do |comment|
          if comment.photos.any?
            @comment_preview = comment.photos.last
            break
          end
        end
      end
      
      if @review_preview && @comment_preview
        if @review_preview.created_at > @comment_preview.created_at
          @preview = @review_preview
        else
          @preview = @comment_preview
        end
      
      elsif @review_preview
        @preview = @review_preview
      
      elsif @comment_preview
        @preview = @comment_preview
      end
      @preview

    elsif @albumable.class.to_s == 'User'
      @preview = @albumable.photos.last
    end
  end
end