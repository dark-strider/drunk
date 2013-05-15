module Likeable
  extend self

  def self.included(l)
    # -Dynamic-
    likes = (l.to_s.downcase+'_likes').to_sym       # :place_likes
    dislikes = (l.to_s.downcase+'_dislikes').to_sym # :place_dislikes

    # -Relationships-
    l.has_and_belongs_to_many :likers, class_name:'Like', inverse_of: likes, autosave: true
    l.has_and_belongs_to_many :dislikers, class_name:'Like', inverse_of: dislikes, autosave: true

    # -Total-
    l.field :total_likers, type: Integer, default: 0
    l.field :total_dislikers, type: Integer, default: 0

    # -Access-
    l.attr_accessible :total_likers, :total_dislikers, as: [:default, :admin, :lord]
  end
end