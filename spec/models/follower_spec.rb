require 'rails_helper'

RSpec.describe Follower, type: :model do
  it 'should connect between two users' do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "user_3@email.com"
    user_4 = "wrongemail.com"

    follow = Follower.follow([user_1, user_2])
    expect(follow).to eql({success: true})

    follow = Follower.follow([user_1, user_4])
    expect(follow).to eql({message: "Validation failed: Email is invalid", success: false})

    follow = Follower.follow([user_1, user_2])
    expect(follow).to eql({message: "Already connected", success: false})
  end

  it 'should show list of followers' do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "user_3@email.com"
    user_4 = "other@email.com"

    Follower.follow([user_1, user_2])
    Follower.follow([user_1, user_3])

    followers = Follower.list(user_1)
    expect(followers).to eql({followers: [user_2, user_3], success: true, count: 2})

    followers = Follower.list(user_4)
    expect(followers).to eql({message: "#{user_4} is not exist", success: false})
  end

  it 'should show common followers' do
    user_1 = "user_1@email.com"
    user_2 = "user_2@email.com"
    user_3 = "user_3@email.com"
    user_4 = "other@email.com"
    user_5 = "wrongemail.com"

    Follower.follow([user_1, user_2])
    Follower.follow([user_1, user_3])
    Follower.follow([user_2, user_3])

    followers = Follower.common([user_1, user_2])
    expect(followers).to eql({success: true, followers: [user_3], count: 1})

    followers = Follower.common([user_2, user_3])
    expect(followers).to eql({success: true, followers: [user_1], count: 1})

    followers = Follower.common([user_1, user_3])
    expect(followers).to eql({success: true, followers: [user_2], count: 1})

    followers = Follower.common([user_2, user_4])
    expect(followers).to eql({success: true, followers: [], count: 0})

    followers = Follower.common([user_1, user_5])
    expect(followers).to eql({message: "Validation failed: Email is invalid", :success=>false})
  end
end
