# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /up', type: :request do
  subject { get '/up' }

  it 'returns a 200 status code' do
    subject
    expect(response).to have_http_status(:ok)
    expect(response.body).to eq('<!DOCTYPE html><html><body style="background-color: green"></body></html>')
  end
end
