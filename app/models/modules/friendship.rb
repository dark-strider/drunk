module Friendship
  extend self

  def self.included(user)
    # -Relationships-
    user.embeds_many :friends, inverse_of: :user, validate: false
    # -Nested-
    user.accepts_nested_attributes_for :friends, allow_destroy: true
    # -Total-
    user.field :total_friends, type: Integer, default: 0
    # -Access-
    user.attr_accessible :friends_attributes, :total_friends, as: [:admin, :lord]
  end

  # -Actions-
  def make_friend!(user)
    unless self == user || friend_with?(user)
      self.friends.new(friend_id: user.id)
      user.friends.new(friend_id: self.id, authored: false)
      self.save && user.save
    end
  end

  def accept_friend!(user)
    if unaccepted_friend?(user)
      self.friends.where(friend_id: user.id).first.set(:accepted, true)
      user.friends.where(friend_id: self.id).first.set(:accepted, true)
      total(1, user)
      self.save && user.save
    end
  end

  def remove_friend!(user)
    if friend_with?(user)
      total(-1, user) if self.friends.where(friend_id: user.id, accepted: true).exists?

      self.friends.where(friend_id: user.id).destroy
      user.friends.where(friend_id: self.id).destroy
      self.save && user.save
    end
  end

  def friend_with?(user)
    self.friends.where(friend_id: user.id).exists?
  end

  def unaccepted_friend?(user)
    self.friends.where(friend_id: user.id, authored: false, accepted: false).exists?
  end

  def select_friends(boolean)
    hash = []
    self.friends.where(accepted: boolean).each do |friend|
      if friend.friend_id == nil
        # Удаляем записи о дружбе с пользователями, которые удалили свои аккаунты.
        self.friends.where(friend_id: nil).destroy
      else
        hash << User.find(friend.friend_id)
      end
    end
    hash
  end

  def accepted_friends
    self.friends.where(accepted: true)
  end

  def total_unaccepted_friends
    self.friends.where(authored: false, accepted: false).count
  end

  # def common_friends_with(user)
  #   self.friends & user.friends
  # end

  # def remove_all_friends!
  #   self.friends.each do |friend|
  #     friend.friends.where(friend_id: self.id).destroy
  #   end
  #   self.friends.destroy_all
  # end

private

  def total(i, user)
    self.inc(:total_friends, i)
    user.inc(:total_friends, i)
  end
end