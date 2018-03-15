require 'rails_helper'

RSpec.describe Api::FollowsController, type: :controller do
  describe 'GET /api/follows' do
    let(:valid_attribute) { { email: 'user_1@email.com'} }

    before {
      Follow.connect(['user_1@email.com', 'user_2@email.com'])
    }

    context 'when request attributes are valid' do
      it 'returns success' do
        get "index", params: valid_attribute
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, followers: ['user_2@email.com'], count: 1}.to_json)
      end
    end
  end

  describe 'POST /api/follows' do
    let(:valid_attributes) { { followers: ['user_1@email.com', 'user_2@email.com']} }
    let(:invalid_attributes) { { followers: ['user_2email.com']} }

    context 'when request attributes are valid' do
      it 'returns success' do
        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true}.to_json)
      end
    end

    context 'when request attributes are invalid' do
      it 'returns invalid email' do
        post "create", params: invalid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email is invalid", success: false}.to_json)
      end
    end
  end

  describe 'POST /api/follows/common' do
    before {
      Follow.connect(['user_1@email.com', 'user_2@email.com'])
      Follow.connect(['user_1@email.com', 'user_3@email.com'])
      Follow.connect(['user_1@email.com', 'user_4@email.com'])
      Follow.connect(['user_4@email.com', 'user_2@email.com'])
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

  describe 'POST /follows/block' do
    let(:valid_attributes) { { emails: ['user_1@email.com', 'user_2@email.com']} }
    before {
      Follow.connect(['user_1@email.com', 'user_2@email.com'])
    }

    context 'when request block follower' do
      it 'return success' do
        post "block", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "user_1@email.com blocked user_2@email.com", success: true}.to_json)
        expect(Follow.last.blocked).to eq(true)
      end
    end
  end

  describe 'POST /follows/unblock' do
    let(:valid_attributes) { { emails: ['user_1@email.com', 'user_2@email.com']} }
    before {
      Follow.connect(['user_1@email.com', 'user_2@email.com'])
      Follow.block(['user_1@email.com', 'user_2@email.com'])
    }

    context 'when request unblock follower' do
      it 'return success' do
        post "unblock", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "user_1@email.com unblock user_2@email.com", success: true}.to_json)
        expect(Follow.last.blocked).to eq(false)
      end
    end
  end

  describe 'POST /follows/subscribe' do
    let(:valid_attributes) { { emails: ['user_1@email.com', 'user_2@email.com']} }
    before {
      Follow.connect(['user_1@email.com', 'user_2@email.com'])
    }

    context 'when request subscribe follower' do
      it 'return success' do
        post "subscribe", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "user_1@email.com is subscribe user_2@email.com", success: true}.to_json)
        expect(Follow.first.subscribed).to eq(true)
      end
    end
  end

  describe 'POST /follows/unsubscribe' do
    let(:valid_attributes) { { emails: ['user_1@email.com', 'user_2@email.com']} }
    before {
      Follow.connect(['user_1@email.com', 'user_2@email.com'])
      Follow.subscribe(['user_1@email.com', 'user_2@email.com'])
    }

    context 'when request unsubscribe follower' do
      it 'return success' do
        post "unsubscribe", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "user_1@email.com is unsubscribe user_2@email.com", success: true}.to_json)
        expect(Follow.first.subscribed).to eq(false)
      end
    end
  end

  describe 'POST /follows/send_email' do
    before {
      Follow.connect(['user_1@email.com', 'user_2@email.com'])
    }

    context 'when request send email' do
      it 'returns success' do
        post "send_email", params: {sender: "user_1@email.com", text: "This is text for test"}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, recipients: ["user_2@email.com"]}.to_json)

        post "send_email", params: {sender: "user_2@email.com", text: "This is text for test"}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, recipients: ["user_1@email.com"]}.to_json)
      end
    end
  end
end
