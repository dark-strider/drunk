# encoding: utf-8
class Review
  include Mongoid::Document
  include Mongoid::Timestamps
  include Module::Likeable

  # -Relationships-
  belongs_to :user,  inverse_of: :reviews
  belongs_to :place, inverse_of: :reviews
  has_many :comments, as: :commentable, class_name: 'Comment', inverse_of: :commentable, dependent: :destroy
  has_many :photos, as: :photographic, class_name: 'Photo', inverse_of: :photographic, dependent: :destroy

  # -Static-
  IMPRESSION = { neutral:'Нейтральное', positive:'Позитивное', negative:'Негативное' }

  # -Info-
  field :impression, type: String
  field :content, type: String

  # -Total-
  field :total_comments, type: Integer, default: 0

  # -Access-
  attr_accessible :impression, :content,
                  as: User::DEFAULT
  attr_accessible :user_id, :place_id, :total_comments,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, :place_id, presence: true
  validates :impression, presence: true,
                         inclusion: { in: IMPRESSION.keys.to_s }
  validates :content, presence: true,
                      length: { maximum: 1000 }
end