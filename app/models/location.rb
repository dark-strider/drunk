class Location
  include Mongoid::Document
  # include Geocoder::Model::Mongoid

  # geocoded_by :address # can also be an IP address. By default create geospatial index.
  # Автоматическое преобразование Адреса в координаты происходит в колбеке карты.
  # Поэтому эту функцию Geocoder отключаем.
  # after_validation :geocode #, :if => :address_changed? # auto-fetch coordinates

  # -Relationships-
  embedded_in :geographic, polymorphic: true, inverse_of: :location

  # -Info-
  field :coordinates, type: Array
  field :country, type: String
  field :city, type: String
  field :street, type: String
  # field :address, type: String # Строка должна включать всё: страну, город...

  # -Access-
  attr_accessible :coordinates, :country, :city, :street, #:address,
                  as: User::DEFAULT

  # -Validations-
  validates :country, presence: true,
                      length: { maximum: 30 }
  validates :city, presence: true,
                   length: { maximum: 30 }
  validates :street, presence: true,
                     length: { maximum: 70 }
  
  # def address
  #   self.address = [self.street, self.city, self.country].compact.join(', ')
  # end
end