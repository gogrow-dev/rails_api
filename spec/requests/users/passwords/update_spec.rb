# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PUT /api/v1/users/password?reset_password_token', type: :request do
  let(:user) { create(:user) }
  let(:reset_password_token) { user.send(:set_reset_password_token) }
  let(:password) { 'new_password' }
  let(:params) do
    {
      user: {
        password:,
        reset_password_token:
      }
    }
  end

  subject { put user_password_path, params:, as: :json }

  context 'when the params are correct' do
    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:no_content)
    end

    it 'updates the password' do
      expect { subject }.to change { user.reload.valid_password?(password) }.from(false).to(true)
    end
  end

  context 'when the params are incorrect' do
    context 'when reset_password_token is incorrect' do
      let(:reset_password_token) { 'wrong_token' }

      it 'returns an error response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json[:errors][:reset_password_token]).to eq([ 'is invalid' ])
      end

      it 'does not update the password' do
        expect { subject }.not_to change(user.reload, :encrypted_password)
      end
    end

    context 'when password is blank' do
      let(:password) { '' }

      it 'returns an error response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json[:errors][:password]).to eq([ "can't be blank" ])
      end

      it 'does not update the password' do
        expect { subject }.not_to change(user.reload, :encrypted_password)
      end
    end

    context 'when password is too short' do
      let(:password) { '123' }

      it 'returns an error response' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        subject
        expect(json[:errors][:password]).to eq([ 'is too short (minimum is 6 characters)' ])
      end

      it 'does not update the password' do
        expect { subject }.not_to change(user.reload, :encrypted_password)
      end
    end
  end
end
