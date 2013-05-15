module Mapping
  extend self

  def self.included(call)
    if call.to_s == 'User'
      bool = false
    else
      bool = true
    end

    # -Relationships-
    call.embeds_one :location, as: :geographic, class_name: 'Location', inverse_of: :geographic, validate: bool
    call.delegate :coordinates, :country, :city, :street, to: :location
    # -Nested-
    call.accepts_nested_attributes_for :location
    # -Map-
    call.acts_as_gmappable process_geocoding: false
    # -Access-
    call.attr_accessible :location_attributes, as: [:default, :admin, :lord]
  end

  # -Actions-
  def longitude
    coordinates[0] if coordinates
  end

  def latitude
    coordinates[1] if coordinates
  end
end