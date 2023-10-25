# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/users/sign_out', type: :request do
  let(:user) { create(:user) }
  let(:headers) do
    {
      'Authorization' => get_jwt(user)
    }
  end

  subject { delete destroy_user_session_path, headers: }

  context 'when the user is signed in' do
    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns an empty response' do
      subject
      expect(response.body).to be_empty
    end

    it 'invalidates the existing JWT' do
      expect { subject }.to(change { user.reload.jti })
    end
  end

  context 'when the user is not signed in' do
    let(:headers) { {} }

    it 'returns an unauthorized response' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error message' do
      subject
      expect(json[:error]).to eq('You need to sign in or sign up before continuing.')
    end
  end
end
