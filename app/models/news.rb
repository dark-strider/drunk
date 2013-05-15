# encoding: utf-8
class News
  include Mongoid::Document
  include Mongoid::Timestamps
  include Module::Likeable

  # -Relationships-
  belongs_to :user,  inverse_of: :news
  belongs_to :place, inverse_of: :news
  has_many :comments, as: :commentable, class_name: 'Comment', inverse_of: :commentable, dependent: :destroy

  # -Static-
  CATEGORIES = %w(Новость Событие Акция)

  # -Info-
  field :category, type: String
  field :is_special, type: Boolean, default: false
  field :is_active, type: Boolean, default: false
  field :title, type: String
  field :content, type: String

  # -Total-
  field :total_comments, type: Integer, default: 0

  # -Access-
  attr_accessible :category, :is_active, :title, :content,
                  as: User::DEFAULT
  attr_accessible :user_id, :place_id, :total_comments,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, :place_id, presence: true
  validates :category, presence: true,
                       inclusion: { in: CATEGORIES }
  validates :title, presence: true,
                    length: { maximum: 50 }
  validates :content, presence: true,
                      length: { maximum: 3000 }
end