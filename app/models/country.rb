class Country
  include Mongoid::Document

  # -Relationships-
  has_many :cities, inverse_of: :country, dependent: :restrict

  # -Info-
  field :name, type: String
  field :about, type: String

  # -Total-
  field :total_places, type: Integer, default: 0
  field :total_events, type: Integer, default: 0

  # -Access-
  attr_accessible :name, :about, :total_places, :total_events,
                  as: User::ADMIN

  # -Validations-
  validates :name, presence: true,
                   length: { maximum: 20 }
  validates :about, length: { maximum: 2000 }
end