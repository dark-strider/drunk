class LikesController < ApplicationController
  before_filter :load_target

  def like
    current_user.like!(@target)
    redirect_back
  end

  def unlike
    current_user.unlike!(@target)
    redirect_back
  end

  def dislike
    current_user.dislike!(@target)
    redirect_back
  end

  def undislike
    current_user.undislike!(@target)
    redirect_back
  end

private

  def load_target
    klass = Kernel.const_get(params[:resource_name])
    id = params[:resource_id]
    @target = klass.find(id)
  end
end
