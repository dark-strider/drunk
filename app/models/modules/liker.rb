module Liker
  extend self

  def self.included(user)
    # -Relationships-
    user.has_one :like, inverse_of: :user, dependent: :delete
  end

  # -Actions-
  def liked?(model)
    model.likers.include?(self.like)
  end

  def disliked?(model)
    model.dislikers.include?(self.like)
  end

  def like!(model)
    unless liked?(model)
      undislike!(model)
      model.likers << self.like
      total_likes(1, model)
    end
  end

  def unlike!(model)
    if liked?(model)
      model.likers.delete(self.like)
      total_likes(-1, model)
    end
  end

  def dislike!(model)
    unless disliked?(model)
      unlike!(model)
      model.dislikers << self.like
      total_dislikes(1, model)
    end
  end

  def undislike!(model)
    if disliked?(model)
      model.dislikers.delete(self.like)
      total_dislikes(-1, model)
    end
  end

private

  def total_likes(i, model)
    model_likes = (model.class.name.downcase+'_total_likes').to_sym  # :place_total_likes
    self.like.inc(model_likes, i)
    model.inc(:total_likers, i)
  end

  def total_dislikes(i, model)
    model_dislikes = (model.class.name.downcase+'_total_dislikes').to_sym  # :place_total_dislikes
    self.like.inc(model_dislikes, i)
    model.inc(:total_dislikers, i)
  end
end
