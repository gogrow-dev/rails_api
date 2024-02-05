# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pageable, type: :request do
  let(:scope) { double('ActiveRecord::Relation') }

  before do
    stub_const('TestModel', double('TestModel'))
    allow(TestModel).to receive(:all).and_return(scope)
    allow(scope).to receive(:to_json).and_return('[]')
    allow(Queries::Paginate).to receive(:call).with(scope, page: anything, per_page: anything).and_return(scope)

    controller = Class.new(ActionController::API) do
      include Pageable

      def index
        test_models = paginate(TestModel.all)
        render json: test_models.to_json, status: :ok
      end
    end
    stub_const('MockController', controller)

    Rails.application.routes.disable_clear_and_finalize = true

    Rails.application.routes.draw { get 'mock_paginate_action' => 'mock#index' }
  end
  after { Rails.application.reload_routes! }

  describe 'GET #index' do
    let(:params) { {} }
    subject(:request) { get '/mock_paginate_action', params: }

    context 'when the page parameter is not present' do
      it 'returns status code 200' do
        request
        expect(response).to have_http_status(:ok)
        expect(Queries::Paginate).to have_received(:call).with(scope, page: nil, per_page: 10)
      end
    end

    context 'when the page parameter is present' do
      let(:params) { { page: 2 } }

      it 'returns status code 200' do
        request
        expect(response).to have_http_status(:ok)
        expect(Queries::Paginate).to have_received(:call).with(scope, page: '2', per_page: 10)
      end
    end

    context 'when the per_page parameter is present' do
      let(:params) { { per_page: 20 } }

      it 'returns status code 200' do
        request
        expect(response).to have_http_status(:ok)
        expect(Queries::Paginate).to have_received(:call).with(scope, page: nil, per_page: '20')
      end
    end

    context 'when the page and per_page parameters are present' do
      let(:params) { { page: 2, per_page: 20 } }

      it 'returns status code 200' do
        request
        expect(response).to have_http_status(:ok)
        expect(Queries::Paginate).to have_received(:call).with(scope, page: '2', per_page: '20')
      end
    end
  end
end
