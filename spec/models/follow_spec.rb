require 'rails_helper'

RSpec.describe Follow, type: :model do
  it 'should connect user' do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    follow = Follow.connect([user_1, user_2])
    expect(follow).to eql({success: true})
  end

  it 'should validation email user' do
    user_1 = "user_1@email.com"
    user_2 = "useremail.com"
    follow = Follow.connect([user_1, user_2])
    expect(follow).to eql({message: "Validation failed: Email is invalid", success: false})
  end

  it 'should show followers list' do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "user_3@email.com"
    user_4 = "other@email.com"

    Follow.connect([user_1, user_2])
    Follow.connect([user_1, user_3])

    followers = Follow.list(user_1)
    expect(followers).to eql({followers: [user_2, user_3], success: true, count: 2})

    followers = Follow.list(user_4)
    expect(followers).to eql({message: "#{user_4} not exist", success: false})
  end

  it 'should show common followers' do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "user_3@email.com"
    user_4 = "other@email.com"

    
    Follow.connect([user_1, user_3])
    Follow.connect([user_2, user_3])

    followers = Follow.common([user_1, user_2])
    expect(followers).to eql({success: true, followers: [user_3], count: 1})

    followers = Follow.common([user_2, user_4])
    expect(followers).to eql({success: true, followers: [], count: 0})

  end

  it "should subscribe an email from updates" do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"

    Follow.connect([user_1, user_2])
    followers = Follow.subscribe([user_1, user_2])
    expect(followers).to eql({message: "#{user_1} is subscribe #{user_2}", success: true})
  end

  it "should unsubscribe an email from updates" do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"

    Follow.connect([user_1, user_2])
    followers = Follow.unsubscribe([user_1, user_2])
    expect(followers).to eql({message: "#{user_1} is unsubscribe #{user_2}", success: true})
  end

  it "should block an email from updates" do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"

    Follow.connect([user_1, user_2])
    followers = Follow.block([user_1, user_2])
    expect(followers).to eql({message: "#{user_1} blocked #{user_2}", success: true})
  end

  it "should unblock an email from updates" do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"

    Follow.connect([user_1, user_2])
    followers = Follow.unblock([user_1, user_2])
    expect(followers).to eql({message: "#{user_1} unblock #{user_2}", success: true})
  end

  it "should retrieve all email addresses that can receive updates from an email address" do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "user_3@email.com"
    user_4 = "user_4@email.com"

    status = Follow.send_email(user_1, "Hello this is Foo")
    expect(status).to eq({message: "User not found", success: false})

    Follow.connect([user_1, user_2])
    Follow.connect([user_4, user_1])

    # #retrieve emails
    status = Follow.send_email(user_1, "Hello this is Foo")
    expect(status).to eq(success: true, recipients: [user_2, user_4])

    # #invite email mentioned
    status = Follow.send_email(user_2, "should to invite user_4@email.com")
    expect(status).to eq({success: true, recipients: [user_1, user_4]})

    # #block 1 user
    Follow.block([user_1, user_2])
    status = Follow.send_email(user_1, "We should to invite user_3@email.com")
    expect(status).to eq({success: true, recipients: [user_3]})
  end

  it 'should show invalid email address' do
    email = Follow.new.mail_format("user.com")
    expect(email).to eq(false)
  end

  it 'should show valid email address' do
    email = Follow.new.mail_format("user@email.com")
    expect(email).to eq(true)
  end

  it 'should able scan mentioned email' do
    emails = Follow.new.scan_mail("email user@email.com should be scanned")
    expect(emails.count).to eq(1)
    expect(emails.first).to eq("user@email.com")

    emails = Follow.new.scan_mail("user_1@email.comm and user_2@email.com emails should be scanned")
    expect(emails.count).to eq(2)
    expect(emails.last).to eq("user_2@email.com")
  end
end
