require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

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

  it 'should followers status false' do
    user_1 = User.create("user_1@email.com")
    user_2 = User.create("user_2@email.com")
    status = User.follow?([user_1, user_2])
    expect(status).to eq(false)
  end

  it 'should followers status true' do
    user_1 = User.create("user_1@email.com")
    user_2 = User.create("user_2@email.com")
    connect = User.following([user_1, user_2])
    status = User.follow?([user_1, user_2])
    expect(status).to eq(true)
  end

end
