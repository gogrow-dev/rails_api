# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /healthcheck', type: :request do
  subject { get '/healthcheck' }

  it 'returns a 200 status code' do
    subject
    expect(response).to have_http_status(:ok)
    expect(response.body).to eq('OK')
  end
end
