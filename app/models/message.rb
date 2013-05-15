class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  # -Relationships-
  belongs_to :user, inverse_of: :messages
  belongs_to :whom, class_name: 'User', inverse_of: :received_messages

  # -Info-
  field :content, type: String

  # -Access-
  attr_accessible :content,
                  as: User::DEFAULT
  attr_accessible :user_id, :whom_id,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, :whom_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 200 }
end