class Friend
  include Mongoid::Document

  # -Relationships-
  embedded_in :user, inverse_of: :friends

  # -Info-
  field :friend_id, type: Moped::BSON::ObjectId
  field :accepted,  type: Boolean, default: false
  field :authored,  type: Boolean, default: true

  # -Access-
  attr_accessible :friend_id, :accepted, :authored,
                  as: User::DEFAULT

  # -Validations-
  validates :friend_id, :accepted, :authored, presence: true
end