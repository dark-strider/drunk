class Place
  include Mongoid::Document
  include Mongoid::Timestamps
  include Module::Mapping
  include Module::Likeable

  # -Relationships-
  has_and_belongs_to_many :place_types, inverse_of: :places, autosave: true
  belongs_to :user, inverse_of: :places
  has_many :events, inverse_of: :place  #, dependent: :restrict
  has_many :reviews, inverse_of: :place  #, dependent: :restrict
  has_many :news, inverse_of: :place  #, dependent: :restrict
  has_many :menus, inverse_of: :place, dependent: :destroy
  has_many :albums, as: :albumable, class_name: 'Album', inverse_of: :albumable, dependent: :destroy

  # -Static-
  STATUS = %w(draft show)

  # -Info-
  field :captain, type: Moped::BSON::ObjectId
  field :status, type: String, default: STATUS.first
  field :name, type: String
  field :opened_in, type: Integer
  field :skype, type: String
  field :phone, type: String
  field :about, type: String

  # -Total-
  field :total_events, type: Integer, default: 0
  field :total_news, type: Integer, default: 0
  field :total_albums, type: Integer, default: 0
  field :total_reviews, type: Integer, default: 0

  # -Access-
  attr_accessible :name, :opened_in, :skype, :phone, :about, :place_type_ids,
                  as: User::DEFAULT
  attr_accessible :total_events, :total_news, :total_albums, :total_reviews,
                  as: User::ADMIN
  attr_accessible :user_id, :status, :captain,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, :place_type_ids, presence: true
  validates :status, presence: true,
                     inclusion: { in: STATUS }
  validates :name, presence: true,
                   length: { maximum: 40 }
  validates :opened_in, numericality: { allow_nil: true,
                                        only_integer: true,
                                        greater_than: 1900 }
  validates :skype, length: { maximum: 25 }
  validates :phone, length: { maximum: 25 }
  validates :about, presence: true,
                    length: { maximum: 2000 }
end