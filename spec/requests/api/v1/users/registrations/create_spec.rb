# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/v1/users/sign_up', type: :request do
  let(:user) { attributes_for(:user) }
  let(:headers) { { 'Accept' => 'application/json' } }

  context 'when user is valid' do
    before do
      post user_registration_path, params: { user: }, as: :json
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the user data' do
      expect(json_response[:data][:id]).not_to eq(nil)
      expect(json_response[:data][:attributes][:email]).to eq(user[:email])
      expect(json_response[:data][:attributes][:uid]).to eq(user[:email])
    end
  end

  context 'when the user already exists' do
    subject! do
      create(:user, email: user[:email])
      post user_registration_path, params: { user: }, as: :json
    end

    it 'returns status code 422' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns the validation errors' do
      expect(error_details).to eq(['Email has already been taken'])
    end

    it 'does not create a user' do
      expect {}.not_to change(User, :count)
    end
  end

  context 'when the user is invalid' do
    before do
      post user_registration_path, params: { user: { email:, password: } }, as: :json
    end

    let(:email) { 'example@email.com' }
    let(:password) { 'Password1.' }

    context 'when the email is invalid' do
      let(:email) { 'invalid_email' }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the validation errors' do
        expect(error_details).to eq(['Email is not an email'])
      end

      it 'does not create a user' do
        expect {}.not_to change(User, :count)
      end
    end

    context 'when the password is invalid' do
      let(:password) { 'short' }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the validation errors' do
        expect(error_details).to eq(['Password is too short (minimum is 6 characters)',
                                     'Password is too short (minimum is 6 characters)'])
      end

      it 'does not create a user' do
        expect {}.not_to change(User, :count)
      end
    end
  end
end
