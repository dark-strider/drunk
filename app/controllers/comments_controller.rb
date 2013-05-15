# encoding: utf-8
class CommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  skip_load_resource only: [:new, :create]
  before_filter :load_commentable, only: [:new, :create]
  respond_to :html, :json

  def new # only for false create
    @comment = @commentable.comments.new
    respond_with(@comment)
  end

  def create
    @comment = @commentable.comments.new(params[:comment])
    @comment.id = params[:comment][:id] if params[:comment][:id]
    @comment.user = current_user
    @comment.parent = params[:comment][:parent] if params[:comment][:parent]

    if @comment.save
      total(1)
      flash[:notice] = 'Комментарий добавлен.'
      redirect_back
    else
      flash[:alert] = 'Комментарий не добавлен.'
      render :new
    end
  end

  # should be inline-edit
  def edit
    @simple = true if @comment.commentable_type == 'Photo'
    respond_with(@comment)
  end

  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = 'Комментарий обновлен.'
      redirect_back
    else
      flash[:alert] = 'Комментарий не обновлен.'
      render :edit
    end
  end

  def destroy
    total(-1) if @comment.destroy
    flash[:notice] = 'Комментарий удален.'
    redirect_back
  end

private

  def load_commentable
    klass = Kernel.const_get(params[:comment][:commentable_class])
    id = params[:comment][:commentable_id]
    @commentable = klass.find(id)
  end

  def total(i)
    @comment.user.inc(:total_comments, i)
    @comment.commentable.inc(:total_comments, i)
  end
end