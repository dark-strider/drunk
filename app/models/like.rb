class Like
  include Mongoid::Document

  # -Relationships-
  belongs_to :user, inverse_of: :like

  # -Likeable-
  # place
  has_and_belongs_to_many :place_likes, class_name:'Place', inverse_of: :likers
  has_and_belongs_to_many :place_dislikes, class_name:'Place', inverse_of: :dislikers
  
  # event
  has_and_belongs_to_many :event_likes, class_name:'Event', inverse_of: :likers
  has_and_belongs_to_many :event_dislikes, class_name:'Event', inverse_of: :dislikers
  
  # news
  has_and_belongs_to_many :news_likes, class_name:'News', inverse_of: :likers
  # has_and_belongs_to_many :news_dislikes, class_name:'News', inverse_of: :dislikers
  
  # review
  has_and_belongs_to_many :review_likes, class_name:'Review', inverse_of: :likers
  # has_and_belongs_to_many :review_dislikes, class_name:'Review', inverse_of: :dislikers
  
  # comment
  has_and_belongs_to_many :comment_likes, class_name:'Comment', inverse_of: :likers
  # has_and_belongs_to_many :comment_dislikes, class_name:'Comment', inverse_of: :dislikers
  
  # photo
  has_and_belongs_to_many :photo_likes, class_name:'Photo', inverse_of: :likers
  # has_and_belongs_to_many :photo_dislikes, class_name:'Photo', inverse_of: :dislikers


  # -Total-
  # place
  field :place_total_likes,    type: Integer, default: 0
  field :place_total_dislikes, type: Integer, default: 0
  
  # event
  field :event_total_likes,    type: Integer, default: 0
  field :event_total_dislikes, type: Integer, default: 0
  
  # news
  field :news_total_likes,    type: Integer, default: 0
  # field :news_total_dislikes, type: Integer, default: 0
  
  # review
  field :review_total_likes,    type: Integer, default: 0
  # field :review_total_dislikes, type: Integer, default: 0
  
  # comment
  field :comment_total_likes,    type: Integer, default: 0
  # field :comment_total_dislikes, type: Integer, default: 0
  
  # photo
  field :photo_total_likes,    type: Integer, default: 0
  # field :photo_total_dislikes, type: Integer, default: 0


  # -Access-
  attr_accessible :place_like_ids, :place_dislike_ids,
                  :event_like_ids, :event_dislike_ids,
                  :news_like_ids, #:news_dislike_ids,
                  :review_like_ids, #:review_dislike_ids,
                  :comment_like_ids, #:comment_dislike_ids,
                  :photo_like_ids, #:photo_dislike_ids,
                  as: User::ADMIN

  attr_accessible :place_total_likes, :place_total_dislikes,
                  :event_total_likes, :event_total_dislikes,
                  :news_total_likes, #:news_total_dislikes,
                  :review_total_likes, #:review_total_dislikes,
                  :comment_total_likes, #:comment_total_dislikes,
                  :photo_total_likes, #:photo_total_dislikes,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, presence: true
end