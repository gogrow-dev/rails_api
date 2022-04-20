# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/users/sign_out', type: :request do
  let!(:user) { create(:user, :confirmed) }
  let(:headers) { auth_headers(user) }

  before do
    delete destroy_user_session_path, headers:, as: :json
  end

  context 'when user is signed in' do
    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'when user is not signed in' do
    let(:headers) { {} }

    it 'returns status code 404' do
      expect(response).to have_http_status(:not_found)
    end
  end
end
