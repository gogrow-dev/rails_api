# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/v1/users/passwords', type: :request do
  subject! { put user_password_path(reset_password_token:), params:, as: :json }

  let(:user) { create(:user, :confirmed) }

  context 'when a valid rest_password_token is sent' do
    let(:reset_password_token) { user.send(:set_reset_password_token) }

    context 'with matching passwords' do
      let(:new_password) { 'new_password' }
      let(:params) { { password: new_password, password_confirmation: new_password } }

      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        expect(json_response[:data][:attributes][:email]).to eq(user.email)
      end

      it 'resets the user password' do
        expect(user.reload.valid_password?('new_password')).to eq(true)
      end
    end

    context 'with non-matching passwords' do
      let(:new_password) { 'new_password' }
      let(:params) { { password: new_password, password_confirmation: 'wrong_password' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        expect(error_details).to eq(["Password confirmation doesn't match Password",
                                     "Password confirmation doesn't match Password"])
      end

      it 'does not reset the user password' do
        expect(user.reload.valid_password?('new_password')).to eq(false)
      end
    end
  end

  context 'when an invalid rest_password_token is sent' do
    let(:reset_password_token) { 'invalid_token' }
    let(:params) { { password: 'new_password', password_confirmation: 'new_password' } }

    it 'returns status code 401' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the error message' do
      expect(error_details).to eq(['Unauthorized'])
    end

    it 'does not reset the user password' do
      expect(user.reload.valid_password?('new_password')).to eq(false)
    end
  end
end
