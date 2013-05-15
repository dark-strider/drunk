# encoding: utf-8
class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Module::Likeable

  # -Relationships-
  belongs_to :user, inverse_of: :events
  belongs_to :place, inverse_of: :events
  has_and_belongs_to_many :members, class_name: 'User', inverse_of: :member_of_events
  has_many :invites, inverse_of: :event, dependent: :delete
  has_many :comments, as: :commentable, class_name: 'Comment', inverse_of: :commentable, dependent: :destroy
  has_many :albums, as: :albumable, class_name: 'Album', inverse_of: :albumable, dependent: :destroy

  # -Static-
  CONDITION = { waiting:'Не подтвержден', ready:'Подтвержден', canceled:'Отменен', over:'Окончен', live:'Сейчас' }
  VISIBILITY = { all:'Видят все', friends:'Только друзья', fof:'Только друзья и их друзья' }
  JOINABLE = { all:'Свободное', friends:'Только друзья', fof:'Только друзья и их друзья', invite:'По приглашениям' }
  INVITEABLE = { all:'Все участники', author:'Только я' }

  # -Info-
  field :condition, type: String, default: :waiting
  field :visibility, type: String
  field :joinable, type: String
  field :inviteable, type: String
  field :name, type: String
  field :skype, type: String
  field :phone, type: String
  field :about, type: String
  field :begin_at, type: Time
  field :end_at, type: Time

  # -Total-
  field :total_members, type: Integer, default: 1
  field :total_albums, type: Integer, default: 0
  field :total_comments, type: Integer, default: 0

  # -Access-
  attr_accessible :place_id, :condition, :visibility, :joinable, :inviteable,
                  :name, :skype, :phone, :about, :begin_at, :end_at,
                  as: User::DEFAULT
  attr_accessible :total_members, :total_albums, :total_comments,
                  as: User::ADMIN
  attr_accessible :user_id, :member_ids,
                  as: User::ADMIN

  # -Validations-
  validates :user_id, :place_id, :begin_at, :end_at, presence: true
  validates :condition, presence: true,
                        inclusion: { in: CONDITION.keys.to_s }
  validates :visibility, presence: true,
                         inclusion: { in: VISIBILITY.keys.to_s }
  validates :joinable, presence: true,
                       inclusion: { in: JOINABLE.keys.to_s }
  validates :inviteable, presence: true,
                         inclusion: { in: INVITEABLE.keys.to_s }
  validates :name, presence: true,
                   length: { maximum: 15 }
  validates :skype, length: { maximum: 25 }
  validates :phone, length: { maximum: 25 }
  validates :about, presence: true,
                    length: { maximum: 300 }

  # -Scopes-
  scope :ready, where(:condition.in => [:waiting, :ready]) # Event.ready
  scope :live, where(condition: :live)

  # -Delegates-
  delegate :name, :condition, :begin_at, :end_at, :total_members, to: :place, prefix: true

  # -Actions-
  def can_see?(current_user)
    can = false
    if self.visibility == 'all'
      can = true
    else
      if current_user
        if self.user.id == current_user.id || current_user.role == 'admin' || current_user.role == 'lord'
          can = true
        elsif self.members.include?(current_user)
          can = true
        else
          if self.visibility == 'friends'
            self.user.accepted_friends.each do |f|
              can = true if f.friend_id == current_user.id
            end
          elsif self.visibility == 'fof'
            self.user.accepted_friends.each do |f|
              can = true if f.friend_id == current_user.id
              
              fof_user = User.find(f.friend_id)
              if fof_user && fof_user.friends.any?
                fof_user.accepted_friends.each do |fof|
                  can = true if fof.friend_id == current_user.id
                end
              end
            end
          end
        end
      end
    end
    can
  end

  def can_join?(current_user)
    can = false
    if self.condition != 'canceled' && self.condition != 'over'
      if current_user
        if self.user.id != current_user.id
          unless self.members.include?(current_user)
            if self.joinable == 'all'
              can = true
            elsif self.joinable != 'invite'
              if self.joinable == 'friends'
                self.user.accepted_friends.each do |f|
                  can = true if f.friend_id == current_user.id
                end
              elsif self.joinable == 'fof'
                self.user.accepted_friends.each do |f|
                  can = true if f.friend_id == current_user.id
                  
                  fof_user = User.find(f.friend_id)
                  if fof_user && fof_user.friends.any?
                    fof_user.accepted_friends.each do |fof|
                      can = true if fof.friend_id == current_user.id
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    can
  end

  def can_unjoin?(current_user)
    can = false
    if current_user
      can = self.members.include?(current_user)
    end
    can
  end

  def can_invite?(current_user)
    can = false
    if self.condition != 'canceled' && self.condition != 'over'
      if current_user
        can = true if self.user.id == current_user.id
        can = self.members.include?(current_user) if !can && self.inviteable == 'all'
      end
    end
    can
  end

  def join!(current_user)
    if self.user != current_user
      self.members << current_user
      total(1, current_user)
    end
  end

  def unjoin!(current_user)
    if self.user != current_user
      self.members.delete(current_user)
      total(-1, current_user)
    end
  end

private

  def total(i, current_user)
    self.inc(:total_members, i)
    current_user.inc(:total_join_events, i)
  end
end