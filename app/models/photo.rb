# encoding: utf-8
class Photo
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Module::Likeable

  # -Relationships-
  belongs_to :user, inverse_of: :photos
  belongs_to :photographic, polymorphic: true, inverse_of: :photos
  has_many :comments, as: :commentable, class_name: 'Comment', inverse_of: :commentable, dependent: :destroy

  # -Info-
  # Директивно указываем тип, чтобы при создании распознавало string как _id.
  field :photographic_id, type: Moped::BSON::ObjectId

  # -Total-
  field :total_comments, type: Integer, default: 0

  # -CarrierWave-
  mount_uploader :image, ImageUploader

  # -Access-
  attr_accessible :image, :image_cache,
                  as: User::DEFAULT
  attr_accessible :user_id, :total_comments,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, :image, presence: true
end