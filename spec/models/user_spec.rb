require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:followers) }

  it 'email with invalid format' do
    user = User.new(email: 'users')
    user.save
    expect(user.errors.messages[:email]).to eq(['is invalid'])
  end
  
  it 'should create an email' do
    user_1 = User.create("user_1@email.com")
    expect(User.count).to eq(1)
    expect(user_1.email).to eq("user_1@email.com")
  end

  it 'should show followers status false' do
    user_1 = User.create("user_1@email.com")
    user_2 = User.create("user_2@email.com")
    status = User.follower?([user_1, user_2])
    expect(status).to eq(false)
  end

  it 'should show followers status true' do
    user_1 = User.create("user_1@email.com")
    user_2 = User.create("user_2@email.com")
    status = User.follower?([user_1, user_2])
    expect(status).to eq(false)

    connect = User.following([user_1, user_2])
    status = User.follower?([user_1, user_2])
    expect(status).to eq(true)
  end

  it 'should show subscribers status false' do
    user_1 = User.create("user_1@email.com")
    user_2 = User.create("user_2@email.com")
    status = user_1.subscribed?(user_2)
    expect(status).to eq(false)
  end

  it 'should show subscribers status true' do
    user_1 = User.create("user_1@email.com")
    user_2 = User.create("user_2@email.com")
    Subscribe.create_subscribe([user_2, user_1])
    status = user_1.subscribed?(user_2)
    expect(status).to eq(true)
  end

end
