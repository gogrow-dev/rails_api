# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filterable, type: :request do
  let(:scope) { double('ActiveRecord::Relation') }

  before do
    stub_const('TestModel', double('TestModel'))
    allow(TestModel).to receive(:all).and_return(scope)
    allow(scope).to receive(:to_json).and_return('[]')
    allow(Queries::Filter).to receive(:call).with(scope, filter_conditions: anything).and_return(scope)

    controller = Class.new(ActionController::API) do
      include Filterable

      def index
        test_models = filter(TestModel.all)
        render json: test_models.to_json, status: :ok
      end
    end
    stub_const('MockController', controller)

    Rails.application.routes.disable_clear_and_finalize = true

    Rails.application.routes.draw { get 'mock_filter_action' => 'mock#index' }
  end
  after { Rails.application.reload_routes! }

  describe 'GET #index' do
    let(:params) { {} }
    subject(:request) { get '/mock_filter_action', params: }

    context 'when no filterable fields are defined' do
      it 'returns status code 200' do
        request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when filterable fields are defined' do
      before do
        MockController.filterable_by :email, 'users.created_at' => 'signed_up_at', updated_at: 'last_updated_at'
      end

      context 'when passing non mapped filter names' do
        let(:params) { { email: 'sample@test.com' } }

        it 'returns status code 200' do
          request
          expect(response).to have_http_status(:ok)
          expect(Queries::Filter).to have_received(:call).with(scope, filter_conditions: [{ field: :email, value: 'sample@test.com', relation: '=' }])
        end
      end

      context 'when passing mapped filter names' do
        let(:params) { { 'signed_up_at' => '2020-01-01', 'signed_up_at.rel' => '>=', 'last_updated_at' => '2020-01-01', 'last_updated_at.rel': '<=' } }

        it 'returns status code 200' do
          request
          expect(response).to have_http_status(:ok)
          expect(Queries::Filter).to have_received(:call).with(scope,
                                                               filter_conditions: [{ field: 'users.created_at', value: '2020-01-01', relation: '>=' },
                                                                                   { field: :updated_at, value: '2020-01-01', relation: '<=' }])
        end
      end

      context 'when using is_null' do
        let(:params) { { 'email.rel' => 'is_null' } }

        it 'returns status code 200' do
          request
          expect(response).to have_http_status(:ok)
          expect(Queries::Filter).to have_received(:call).with(scope, filter_conditions: [{ field: :email, value: nil, relation: 'is_null' }])
        end
      end

      context 'when using is_not_null' do
        let(:params) { { 'email.rel' => 'is_not_null' } }

        it 'returns status code 200' do
          request
          expect(response).to have_http_status(:ok)
          expect(Queries::Filter).to have_received(:call).with(scope, filter_conditions: [{ field: :email, value: nil, relation: 'is_not_null' }])
        end
      end
    end
  end
end
