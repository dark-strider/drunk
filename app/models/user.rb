# encoding: utf-8
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Module::Mapping
  include Module::Friendship
  include Module::Liker

  # -Relationships-
  has_many :services, inverse_of: :user, dependent: :delete
  has_many :events, inverse_of: :user
  has_and_belongs_to_many :member_of_events, class_name: 'Event', inverse_of: :members, autosave: true
  has_many :places, inverse_of: :user
  has_many :reviews, inverse_of: :user
  has_many :news, inverse_of: :user
  has_many :menus, inverse_of: :user
  has_many :messages, inverse_of: :user
  has_many :received_messages, class_name: 'Message', inverse_of: :whom
  has_many :invites, inverse_of: :user
  has_many :received_invites, class_name: 'Invite', inverse_of: :whom
  has_many :comments, inverse_of: :user
  has_many :photos, inverse_of: :user
  has_many :albums, as: :albumable, class_name: 'Album', inverse_of: :albumable, dependent: :destroy

  # -Nested-
  accepts_nested_attributes_for :services, allow_destroy: true

  # -Static-
  ROLES = %w(user moderator admin lord)
  GENDERS = %w(Мужской Женский)
  #[access rules]
  DEFAULT = [:default, :admin, :lord]
  ADMIN = [:admin, :lord]
  LORD = [:lord]

  # -Devise-
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  field :email,                  type: String, default: ''
  field :encrypted_password,     type: String, default: ''
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time
  field :remember_created_at,    type: Time
  field :sign_in_count,          type: Integer, default: 0
  field :current_sign_in_at,     type: Time
  field :last_sign_in_at,        type: Time
  field :current_sign_in_ip,     type: String
  field :last_sign_in_ip,        type: String

  # -Omniauth-
  field :by_oauth,    type: Boolean, default: false # def password_required?
  field :my_password, type: Boolean, default: true  # require password change

  # -CanCan-
  field :role, type: String, default: ROLES.first

  # -Info-
  field :name, type: String
  field :birthday, type: Date
  field :gender, type: String, default: GENDERS.first
  field :skype, type: String
  field :phone, type: String
  field :about, type: String
  field :hobbies, type: String
  
  # -CarrierWave-
  mount_uploader :avatar, AvatarUploader

  # -Total-
  field :total_create_events, type: Integer, default: 0
  field :total_join_events, type: Integer, default: 0
  field :total_create_messages, type: Integer, default: 0
  field :total_received_messages, type: Integer, default: 0
  field :total_comments, type: Integer, default: 0
  field :total_albums, type: Integer, default: 0
  field :total_reviews, type: Integer, default: 0

  # -Access-
  #[all]
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :by_oauth, :my_password,
                  :name, :birthday, :gender, :skype, :phone, :about, :hobbies, :avatar, :avatar_cache,
                  as: User::DEFAULT
  #[admin](only in dashboard)
  attr_accessible :reset_password_token, :reset_password_sent_at,
                  :remember_created_at, :sign_in_count, :current_sign_in_at,
                  :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip,
                  as: User::ADMIN
  attr_accessible :total_create_events, :total_join_events, :total_create_messages,
                  :total_received_messages, :total_comments, :total_albums, :total_reviews,
                  as: User::ADMIN
  attr_accessible :services_attributes, allow_destroy: true,
                  as: User::ADMIN
  #[lord](only in dashboard)
  attr_accessible :role,
                  as: User::LORD

  # -Validations-
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 320 }
  validates :password, presence: { if: :password_required? },
                       confirmation: true
  validates :role, presence: true,
                   length: { in: 1..9 },
                   inclusion: { in: ROLES }
  validates :name, presence: true,
                   length: { in: 2..40 }
  validates :gender, inclusion: { in: GENDERS }
  validates :skype, length: { maximum: 25 }
  validates :phone, length: { maximum: 25 }
  validates :about, length: { maximum: 1000 }
  validates :hobbies, length: { maximum: 1000 }

  # -Actions-
  def self.new_with_session(params, session)
  # Вызывается автоматически из SignupController,
  # для инициализации данных до регистрации.
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && new_record? && !by_oauth?
  end

  def total_events
    self.total_create_events + self.total_join_events
  end

  def total_messages
    self.total_create_messages + self.total_received_messages
  end
end