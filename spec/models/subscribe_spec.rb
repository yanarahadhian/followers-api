require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  
  it 'should subscribe an email' do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "wrongemail.com"

    status = Subscribe.store(user_1, user_2)
    expect(status).to eq({success: true})

    user = User.find_by_email(user_2)
    expect(user.subscribe.count).to eq(1)

    status = Subscribe.store(user_1, user_3)
    expect(status).to eq({message: "Validation failed: Email is invalid", success: false})
  end

  it "should block and unblock an email from updates" do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "user_3@email.com"
    user_4 = "wrongemail.com"

    Subscribe.store(user_1, user_2)
    user_a = User.find_by_email(user_1)
    user_b = User.find_by_email(user_2)

    status = user_b.subscribes.find_by(subscribe_id: user_a.id).block
    expect(status).to eq(false)

    #block
    Subscribe.block(user_2, user_1)
    status = user_b.subscribes.find_by(subscribe_id: user_a.id).block
    expect(status).to eq(true)

    #unblock
    Subscribe.unblock(user_2, user_1)
    status = user_b.subscribes.find_by(subscribe_id: user_a.id).block
    expect(status).to eq(false)
  end

  it "should retrieve all email addresses that can receive updates from an email address" do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "user_3@email.com"
    user_4 = "user_4@email.com"
    user_5 = "wrongemail.com"

    #failed
    status = Subscribe.send_email(user_1, "Hello this is Foo")
    expect(status).to eq({message: "User not found", success: false})

    Follower.follow([user_1, user_2])
    Subscribe.store(user_4, user_1)

    #retrieve emails
    status = Subscribe.send_email(user_1, "Hello this is Foo")
    expect(status).to eq(success: true, recipients: [user_2, user_4])

    #invalid email
    status = Subscribe.send_email(user_5, "Hello this is Foo")
    expect(status).to eq(message: "#{user_5} is invalid email", success: false)

    #invite email mentioned
    status = Subscribe.send_email(user_2, "We should to invite user_4@email.com")
    expect(status).to eq({success: true, recipients: [user_1, user_4]})

    #block user
    Subscribe.block(user_1, user_2)
    status = Subscribe.send_email(user_1, "We should to invite user_4@email.com and user_3@email.com")
    expect(status).to eq({success: true, recipients: [user_4, user_3]})

    #unblock user
    Subscribe.unblock(user_1, user_2)
    status = Subscribe.send_email(user_1, "We should to invite user_4@email.com and user_3@email.com")
    expect(status).to eq({success: true, recipients: [user_2, user_4, user_3]})
  end

  it 'should show invalid email address' do
    email = Subscribe.new.mail_format("user.com")
    expect(email).to eq(false)
  end

  it 'should show valid email address' do
    email = Subscribe.new.mail_format("user@email.com")
    expect(email).to eq(true)
  end

  it 'should able scan mentioned email' do
    emails = Subscribe.new.scan_mail("This is just test for scan user@email.com")
    expect(emails.count).to eq(1)
    expect(emails.first).to eq("user@email.com")

    emails = Subscribe.new.scan_mail("This is just test for scan user_1@email.comm and another user_2@email.com")
    expect(emails.count).to eq(2)
    expect(emails.last).to eq("user_2@email.com")
  end

end
