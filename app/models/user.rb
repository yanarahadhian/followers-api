class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

  def self.create(email)
    self.find_or_create_by!(email: email)
  end

  def self.follow?(users)
    users.first.followers.include?(users.last)
  end

  def self.following(users)
    Follow.create(follower_id: users.first.id, following_id: users.last.id)
    Follow.create(follower_id: users.last.id, following_id: users.first.id)
  end

end
