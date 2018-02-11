class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  has_many :subscribes
  has_many :subscribe, :through => :subscribes

  has_many :followers
  has_many :follower, :through => :followers

  def self.create(email)
    self.find_or_create_by!(email: email)
  end

  def self.follower?(users)
    user_1 = users.first
    user_2 = users.last
    user_1.connected?(user_2)
  end

  def self.following(users)
    users.first.followers.create(follower_id: users.last.id)
    users.last.followers.create(follower_id: users.first.id)
    Subscribe.connecting(users)
  end

  def connected?(target)
    follower.include?(target)
  end

  def subscribed?(user)
    self.subscribe.include?(user)
  end

end
