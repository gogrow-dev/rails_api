# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/users/confirmation?confirmation_token', type: :request do
  let(:user) { create(:user, :unconfirmed) }
  let(:confirmation_token) { user.confirmation_token }

  subject { get user_confirmation_path(confirmation_token:), as: :json }

  context 'when the confirmation_token is valid' do
    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'confirms the user' do
      expect { subject }.to change { user.reload.confirmed? }.from(false).to(true)
    end
  end

  context 'when the confirmation_token is invalid' do
    let(:confirmation_token) { 'wrong_token' }

    it 'returns an error status code' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns an error message' do
      subject
      expect(json[:confirmation_token]).to eq(['is invalid'])
    end

    it 'does not confirm the user' do
      expect { subject }.not_to change(user.reload, :confirmed?)
    end
  end
end
