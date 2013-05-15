class Service
  include Mongoid::Document

  # -Relationships-
  belongs_to :user, inverse_of: :services

  # -Info-
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :email, type: String
  field :url, type: String

  # -Access-
  attr_accessible :provider, :uid, :name, :email, :url,
                  as: User::DEFAULT

  # -Validations-
  validates :user_id, :provider, :uid, presence: true
  
private

  # -Actions-
  # Переделать в create в контроллере.
  def self.add(user, provider, uid, name, email, url)
    user.services.create(provider: provider, uid: uid, name: name, email: email, url: url)
  end
end