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

end
