# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/v1/users/sign_up', type: :request do
  let!(:user) { create(:user, :confirmed) }
  let(:email) { user.email }
  let(:password) { user.password }
  let(:password_confirmation) { user.password }
  let(:params) do
    {
      user: {
        email:,
        password:,
        password_confirmation:
      }
    }
  end

  before do
    put user_registration_path, params:, headers: auth_headers(user), as: :json
  end

  context 'when user credentials are valid' do
    context 'when the new email is valid' do
      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user data' do
        expect(json_response[:data][:id]).not_to eq(nil)
        expect(json_response[:data][:email]).to eq(user.email)
        expect(json_response[:data][:uid]).to eq(user.email)
      end
    end

    context 'when the new email is invalid' do
      let(:email) { 'invalid_email' }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data for the errors' do
        expect(json_response[:errors][:full_messages]).to eq(['Email is not an email'])
      end
    end

    context 'when the password and password_confirmation dont match' do
      let(:password) { 'new_password' }
      let(:password_confirmation) { 'invalid_password' }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the json data for the errors' do
        expect(json_response[:errors][:full_messages]).to eq(['Password confirmation doesn\'t match Password',
                                                              'Password confirmation doesn\'t match Password'])
      end
    end
  end
end
