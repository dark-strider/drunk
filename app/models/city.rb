class City
  include Mongoid::Document

  # -Relationships-
  belongs_to :country, inverse_of: :cities

  # -Info-
  field :name, type: String
  field :about, type: String

  # -Total-
  field :total_places, type: Integer, default: 0
  field :total_events, type: Integer, default: 0

  # -Access-
  attr_accessible :country_id, :name, :about, :total_places, :total_events,
                  as: User::ADMIN

  # -Validations-
  validates :country_id, presence: true
  validates :name, presence: true,
                   length: { maximum: 20 }
  validates :about, length: { maximum: 2000 }
end