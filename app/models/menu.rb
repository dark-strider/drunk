# encoding: utf-8
class Menu
  include Mongoid::Document
  include Mongoid::Timestamps

  # -Relationships-
  belongs_to :user,  inverse_of: :menus
  belongs_to :place, inverse_of: :menus

  # -Static-
  SECTIONS = ['Алкогольные напитки', 'Безалкогольные напитки', 'Салаты', 'Горячее']

  # -Info-
  field :section, type: String
  field :name, type: String
  field :about, type: String
  field :price, type: Float

  # -CarrierWave-
  mount_uploader :menu, MenuUploader

  # -Access-
  attr_accessible :section, :name, :about, :price, :menu, :menu_cache,
                  as: User::DEFAULT
  attr_accessible :user_id, :place_id,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, :place_id, presence: true
  validates :section, presence: true,
                      inclusion: { in: SECTIONS }
  validates :name, presence: true,
                  length: { maximum: 40 }
  validates :about, length: { maximum: 200 }
  validates :price, presence: true,
                    numericality: { greater_than: 0 }
end