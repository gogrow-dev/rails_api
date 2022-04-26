# frozen_string_literal: true

RSpec.describe 'POST /api/v1/users/passwords', type: :request do
  let(:user) { create(:user, :confirmed) }

  context 'with valid params' do
    subject! do
      post user_password_path, params: { email: user.email }, as: :json
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end

    it 'sends an email with the password reset instructions' do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  context 'when the user is not confirmed' do
    subject! do
      post user_password_path, params: { email: user.email }, as: :json
    end

    let(:user) { create(:user) }

    it 'returns status code 201' do
      expect(response).to have_http_status(:created)
    end

    it 'Sends an email' do
      expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      expect(ActionMailer::Base.deliveries.last.subject).to eq('Reset password instructions')
    end
  end

  context 'with invalid params' do
    context 'when the user does not exist' do
      subject! { post user_password_path, params: { email: 'user@example.com' }, as: :json }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns email not found error message' do
        expect(error_details).to eq(["Unable to find user with email 'user@example.com'."])
      end

      it 'does not send an email' do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end
