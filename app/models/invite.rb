# encoding: utf-8
class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  # -Relationships-
  belongs_to :user, inverse_of: :invites
  belongs_to :event, inverse_of: :invites
  belongs_to :whom, class_name: 'User', inverse_of: :received_invites

  # -Static-
  STATUS = { waiting:'Ожидание', refused:'Отклонено' }

  # -Info-
  field :status, type: String, default: STATUS.first[0]
  field :about, type: String

  # -Access-
  attr_accessible :status, :about,
                  as: User::DEFAULT
  attr_accessible :user_id, :event_id, :whom_id,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, :event_id, :whom_id, presence: true
  validates :status, presence: true,
                     inclusion: { in: STATUS.keys.to_s }
  validates :about, length: { maximum: 200 }

  # -Actions-
  def accept!(event, current_user)
    if event.members.include?(current_user)
      self.destroy
    else
      if self.whom == current_user
        if event.join!(current_user)
          event.save && self.destroy
        end
      end
    end
  end

  def refuse!(current_user)
    if self.whom == current_user
      if self.status == 'waiting'
        self.set(:status, 'refused')
        self.save
      end
    end
  end
end