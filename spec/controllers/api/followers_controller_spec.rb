require 'rails_helper'

RSpec.describe Api::FollowersController, type: :controller do

  describe 'GET /api/followers' do
    let(:valid_attribute) { { email: 'user_1@email.com'} }

    before {
      Follower.follow(['user_1@email.com', 'user_2@email.com'])
    }

    context 'when request attributes are valid' do
      it 'returns success' do
        get "index", params: valid_attribute
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, followers: ['user_2@email.com'], count: 1}.to_json)
      end
    end
  end

  describe 'POST /api/followers' do
    let(:valid_attributes) { { followers: ['user_1@email.com', 'user_2@email.com']} }
    let(:invalid_attributes) { { followers: ['user_1@email.com', 'user_2email.com']} }
    let(:wrong_input_attributes) { { followers: ['user_1@email.com']} }

    context 'when request attributes are valid' do
      it 'returns success' do
        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true}.to_json)

        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Already connected", success: false}.to_json)
      end
    end

    context 'when request attributes are invalid' do
      it 'returns invalid email' do
        post "create", params: invalid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email is invalid", success: false}.to_json)
      end
    end

    context 'when request attributes are wrong' do
      it 'returns invalid input array' do
        post "create", params: wrong_input_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Required 2 emails", success: false}.to_json)
      end
    end
  end

  describe 'POST /api/followers/common' do
    before {
      Follower.follow(['user_1@email.com', 'user_2@email.com'])
      Follower.follow(['user_1@email.com', 'user_3@email.com'])
      Follower.follow(['user_1@email.com', 'user_4@email.com'])
      Follower.follow(['user_4@email.com', 'user_2@email.com'])
    }

    context 'when request by 2 emails' do
      it 'returns success' do
        post "common", params: {followers: ['user_1@email.com', 'user_2@email.com']}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, followers: ['user_4@email.com'], count: 1}.to_json)
      end

      it 'returns empty common friends' do
        post "common", params: {followers: ['user_1@email.com', 'user_3@email.com']}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, followers: [], count: 0}.to_json)
      end
    end
  end

end
