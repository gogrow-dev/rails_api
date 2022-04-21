# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/users/sign_in', type: :request do
  let!(:user) { create(:user, :confirmed) }
  let(:params) { { user: { email: user.email, password: user.password } } }

  before do
    post user_session_path, params:, as: :json
  end

  context 'when user credentials are valid' do
    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the user data' do
      expect(json_response[:data][:id]).not_to eq(nil)
      expect(json_response[:data][:email]).to eq(user.email)
      expect(json_response[:data][:uid]).to eq(user.email)
    end

    it 'returns the auth headers' do
      expect(response.headers['access-token']).not_to eq(nil)
      expect(response.headers['client']).not_to eq(nil)
      expect(response.headers['uid']).to eq(user.email)
    end
  end

  context 'when user credentials are invalid' do
    context 'when the email is invalid' do
      let(:params) { { user: { email: 'nonexistant@email.com', password: user.password } } }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the json data for the errors' do
        expect(json_response[:errors]).to eq(['Invalid login credentials. Please try again.'])
      end
    end

    context 'when the password is invalid' do
      let(:params) { { user: { email: user.email, password: 'invalid_password' } } }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the json data for the errors' do
        expect(json_response[:errors]).to eq(['Invalid login credentials. Please try again.'])
      end
    end
  end
end
