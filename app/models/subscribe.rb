class Subscribe < ApplicationRecord

  belongs_to :user
  belongs_to :subscribe, :class_name => 'User'

  validates_uniqueness_of :user_id, :scope => :subscribe_id, message: "Already subscribe"
  validates :subscribe_id, presence: true

  def self.connecting(users)
    users.first.subscribes.create(subscribe_id: users.last.id)
    users.last.subscribes.create(subscribe_id: users.first.id)
  end

  def self.create_subscribe(users)
    users.last.subscribes.create!(subscribe_id: users.first.id) unless users.last.subscribed?(users.first)
  end

  def self.store(from, to)
    users = []
    [from, to].each do |email|
      begin
        users << User.find_or_create_by!(email: email)
      rescue => e
        return {message: e.to_s, success: false}
      end
    end

    Subscribe.create_subscribe(users)
    return {success: true}
  end

  def self.block(from, to)
    action = Subscribe.init_block(from, to, "block")
    return action
  end

  def self.unblock(from, to)
    action = Subscribe.init_block(from, to, "unblock")
    return action
  end

  def self.init_block(from, to, type)
    users = []
    [from, to].each do |email|
      user = User.find_by(email: email)
      users << user
    end

    req = users.first
    tar = users.last
    
    case type
    when "block"
      req.subscribes.find_by_subscribe_id(tar.id).update_attribute(:block, true)
      return {success: true}
    when "unblock"
      req.subscribes.find_by_subscribe_id(tar.id).update_attribute(:block, false)
      return {success: true}
    end
  end

  def self.send_email(sender, text)
    return {message: "#{sender} is invalid email", success: false} unless self.new.mail_format(sender)
    user = User.find_by_email(sender)
    return {message: "User not found", success: false} if user.blank?
    Subscribe.scan_email(user, text)
    follower_ids = user.follower_ids
    block_ids = user.subscribes.where(block: true).map(&:subscribe_id)
    non_block_ids = user.subscribes.where(block: false).map(&:subscribe_id)
    recipients = (follower_ids + non_block_ids).select{|x| block_ids.exclude?(x)}.uniq || []
    return {success: true, recipients: User.find(recipients).map(&:email)}
  end

  def self.scan_email(user, text)
    emails = []
    self.new.scan_mail(text).each do |email|
      emails << email
    end
    emails.each do |email|
      requestor = User.create(email)
      Subscribe.create_subscribe([requestor, user])
    end
  end

  def scan_mail(text)
    text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)
  end

  def mail_format(email)
    return (email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i).present?
  end

end
