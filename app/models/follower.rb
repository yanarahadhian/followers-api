class Follower < ApplicationRecord
  belongs_to :user
  belongs_to :follower, :class_name => 'User'

  validates_uniqueness_of :user_id, scope: :follower_id

  def self.follow(emails)
    return {message: 'Required 2 emails', success: false} if emails.length != 2
    users = []
    emails.each do |email|
      begin
        users << User.create(email)
      rescue => e
        return {message: e.to_s, success: false}
      end
    end

    if User.follower?(users)
      return {message: "Already connected", success: false}
    else
      User.following(users)
      return {success: true}
    end
  end

  def self.list(email)
    user = User.find_by_email(email)
    if user.present?
      followers = user.follower.map(&:email)
      count = followers.count
      return {success: true, followers: followers, count: count}
    else
      return {message: "#{email} is not exist", success: false}
    end
  end

  def self.common(emails)
    users = []
    emails.each do |email|
      begin
        users << User.create(email)
      rescue => e
        return {message: e.to_s, success: false}
      end
    end

    a = users.first.follower
    b = users.last.follower
    commons = a.select{|x| b.include?(x)}.map(&:email) || []
    return {success: true, followers: commons, count: commons.count}
  end

end
