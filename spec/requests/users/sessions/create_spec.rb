# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'POST /api/users/sign_in', type: :request do
  let(:user) { create(:user) }
  let(:email) { user.email }
  let(:password) { user.password }
  let(:params) do
    {
      user: { email:, password: }
    }
  end

  subject { post user_session_path, params:, as: :json }

  context 'when the credentials are correct' do
    context 'when the user email is confirmed' do
      it 'returns a successful response' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'returns the user' do
        subject
        expect(json[:id]).to eq(user.id)
        expect(json[:email]).to eq(user.email)
        expect(json[:created_at]).to eq(user.created_at.strftime('%F %T %Z'))
      end

      it 'returns a valid client and access token' do
        subject
        expect(response.header['Authorization']).to be_present
      end
    end

    context 'when the user email is not confirmed' do
      let(:user) { create(:user, :unconfirmed) }

      it 'returns an unauthorized response' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        subject
        expect(json[:error]).to eq('You have to confirm your email address before continuing.')
      end

      it 'does not return a valid client and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end
    end
  end

  context 'when the credentials are incorrect' do
    context 'when email is incorrect' do
      let(:email) { 'incorrect@email.com' }

      it 'returns an unauthorized response' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        subject
        expect(json[:error]).to eq('Invalid Email or password.')
      end

      it 'does not return a valid client and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end
    end

    context 'when password is incorrect' do
      let(:password) { 'incorrect_password' }

      it 'returns an unauthorized response' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        subject
        expect(json[:error]).to eq('Invalid Email or password.')
      end

      it 'does not return a valid client and access token' do
        subject
        expect(response.header['Authorization']).to be_nil
      end
    end
  end
end
