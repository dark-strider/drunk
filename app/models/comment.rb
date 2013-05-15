class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Module::Likeable

  # -Relationships-
  belongs_to :user, inverse_of: :comments
  belongs_to :commentable, polymorphic: true, inverse_of: :comments

  belongs_to :parent, class_name: 'Comment', inverse_of: :answers
  has_many :answers, class_name: 'Comment', inverse_of: :parent

  has_many :photos, as: :photographic, class_name: 'Photo', inverse_of: :photographic, dependent: :destroy

  # -Info-
  field :content, type: String

  # -Access-
  attr_accessible :content,
                  as: User::DEFAULT
  attr_accessible :user_id, :parent_id,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 500 }
end