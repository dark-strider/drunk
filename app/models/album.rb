class Album
  include Mongoid::Document
  include Mongoid::Timestamps

  # -Relationships-
  belongs_to :user, inverse_of: :albums
  belongs_to :albumable, polymorphic: true, inverse_of: :albums
  has_many :photos, as: :photographic, class_name: 'Photo', inverse_of: :photographic, dependent: :destroy

  # -Info-
  field :name, type: String
  field :about, type: String

  # -Total-
  field :total_photos, type: Integer, default: 0

  # -Access-
  attr_accessible :name, :about,
                  as: User::DEFAULT
  attr_accessible :user_id, :total_photos,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, presence: true
  validates :name, presence: true,
                   length: { maximum: 20 }
  validates :about, length: { maximum: 100 }
end