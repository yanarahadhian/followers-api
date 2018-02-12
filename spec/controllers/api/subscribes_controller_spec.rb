require 'rails_helper'

RSpec.describe Api::SubscribesController, type: :controller do

  describe 'POST /subscribes' do
    let(:valid_attributes) { { requestor: 'user_1@email.com', target: 'user_2@email.com'} }
    let(:invalid_attributes) { { requestor: 'user_1@email.com', target: 'user_2email.com'} }
    let(:wrong_input_attributes) { { requestor: 'user_1@email.com', target: nil} }

    context 'when request attributes are valid' do
      it 'return success' do
        post "create", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true}.to_json)
      end
    end

    context 'when request attributes are invalid' do
      it 'return email invalid' do
        post "create", params: invalid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email is invalid", success: false}.to_json)
      end
    end

    context 'when request use wrong parameters' do
      it 'returns validation failed' do
        post "create", params: wrong_input_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({message: "Validation failed: Email can't be blank, Email is invalid", success: false}.to_json)
      end
    end
  end

  describe 'POST /subscribes/block' do
    let(:valid_attributes) { { requestor: 'user_1@email.com', target: 'user_2@email.com'} }
    before {
      Subscribe.store("user_2@email.com", "user_1@email.com")
    }

    context 'when request use wrong parameters' do
      it 'return success' do
        post "block", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true}.to_json)
        expect(Subscribe.first.block).to eq(true)
      end
    end
  end

  describe 'POST /subscribes/unblock' do
    let(:valid_attributes) { { requestor: 'user_1@email.com', target: 'user_2@email.com'} }
    before {
      Subscribe.store("user_2@email.com", "user_1@email.com")
      Subscribe.block("user_1@email.com", "user_2@email.com")
    }

    context 'when request use wrong parameters' do
      it 'returns something wrong' do
        post "unblock", params: valid_attributes
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true}.to_json)
        expect(Subscribe.first.block).to eq(false)
      end
    end
  end

  describe 'POST /subscribes/send_email' do
    before {
      Subscribe.store("user_2@email.com", "user_1@email.com")
    }

    context 'when request use wrong parameters' do
      it 'returns success' do
        post "send_email", params: {sender: "user_1@email.com", text: "This is text for test"}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, recipients: ["user_2@email.com"]}.to_json)

        post "send_email", params: {sender: "user_2@email.com", text: "This is text for test"}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, recipients: []}.to_json)
      end

      it 'returns success and get new subscribers retrieve from email content' do
        post "send_email", params: {sender: "user_2@email.com", text: "This is text for test x@mail.com and y@email.com"}
        expect(response).to have_http_status(200)
        expect(response.body).to eq({success: true, recipients: ['x@mail.com', 'y@email.com']}.to_json)
      end
    end
  end

end
