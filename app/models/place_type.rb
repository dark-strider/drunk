class PlaceType
  include Mongoid::Document

  # -Relationships-
  has_and_belongs_to_many :places, inverse_of: :place_types

  # -Info-
  field :name, type: String

  # -Access-
  attr_accessible :name,
                  as: User::ADMIN

  # -Validations-
  validates :name, presence: true,
                   length: { maximum: 30 }
end