class Follow < ApplicationRecord
  belongs_to :follower, foreign_key: 'follower_id', class_name: 'User'
  belongs_to :following, foreign_key: 'following_id', class_name: 'User'

  def self.connect(emails)
    users = []
    if emails.present?
      emails.each do |email|
        begin
          users << User.create(email)
        rescue => e
          return {message: e.to_s, success: false}
        end
      end
    end

    if User.following(users)
      return {success: true}
    end
  end

  def self.list(email)
    user = User.find_by_email(email)
    if user.present?
      followers = user.followers.map(&:email)
      count = followers.count
      return {success: true, followers: followers, count: count}
    else
      return {message: "#{email} not exist", success: false}
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

    a = users.first.followers
    b = users.last.followers
    commons = a.select{|x| b.include?(x)}.map(&:email) || []
    return {success: true, followers: commons, count: commons.count}
  end

  def self.subscribe(emails)
    user_1 = User.find_by_email(emails.first)
    user_2 = User.find_by_email(emails.last)

    user_1.following_relationships.update(subscribed: true)
    return {message: "#{user_1.email} is subscribe #{user_2.email}", success: true}
  end

  def self.unsubscribe(emails)
    user_1 = User.find_by_email(emails.first)
    user_2 = User.find_by_email(emails.last)

    user_1.following_relationships.update(subscribed: false)
    return {message: "#{user_1.email} is unsubscribe #{user_2.email}", success: true}
  end

  def self.block(emails)
    user_1 = User.find_by_email(emails.first)
    user_2 = User.find_by_email(emails.last)

    user_1.follower_relationships.update(blocked: true)
    return {message: "#{user_1.email} blocked #{user_2.email}", success: true}
  end

  def self.unblock(emails)
    user_1 = User.find_by_email(emails.first)
    user_2 = User.find_by_email(emails.last)

    user_1.follower_relationships.update(blocked: false)
    return {message: "#{user_1.email} unblock #{user_2.email}", success: true}
  end

  def self.send_email(email, text)
    return {message: "#{email} is invalid email", success: false} unless self.new.mail_format(email)
    user = User.find_by_email(email)
    return {message: "User not found", success: false} if user.blank?

    users = []
    emails = []
    self.new.scan_mail(text).each do |email|
      emails << email
    end
    emails.each do |email|
      users << User.create(email)
      users << user
      User.following(users)
    end

    follower_ids = user.follower_ids
    block_ids = user.follower_relationships.where(blocked: true).map(&:follower_id)
    non_block_ids = user.follower_relationships.where(blocked: false).map(&:follower_id)
    subscribed_ids = user.following_relationships.where(blocked: true).map(&:following_id)
    non_subscribe_ids = user.following_relationships.where(blocked: false).map(&:following_id)
    recipients = (follower_ids + non_block_ids + non_subscribe_ids).select{|x| (block_ids + subscribed_ids).exclude?(x)}.uniq || []
    return {success: true, recipients: User.find(recipients).map(&:email)}
  end

  def scan_mail(text)
    text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
  end

  def mail_format(email)
    return (email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i).present?
  end

end
