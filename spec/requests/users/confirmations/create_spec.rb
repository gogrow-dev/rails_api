# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users/confirmations', type: :request do
  let(:user) { create(:user, :unconfirmed) }
  let(:email) { user.email }
  let(:params) do
    {
      user: { email: }
    }
  end

  subject { post user_confirmation_path, params:, as: :json }

  context 'when the params are correct' do
    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:created)
    end

    it 'sends an email with the confirmation_token' do
      expect { subject }.to change(ActionMailer::Base.deliveries, :count)
    end
  end

  context 'when the params are incorrect' do
    let(:email) { 'wrong_email' }

    it 'returns an error response' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns an error message' do
      subject
      expect(json[:errors][:email]).to eq(['not found'])
    end

    it 'does not send an email' do
      expect { subject }.not_to change(ActionMailer::Base.deliveries, :count)
    end

    it 'does not generate a confirmation token' do
      expect { subject }.not_to change(user.reload, :confirmation_token)
    end
  end
end
