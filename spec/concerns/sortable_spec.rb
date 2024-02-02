# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sortable, type: :request do
  let(:scope) { double('ActiveRecord::Relation') }

  before do
    stub_const('TestModel', double('TestModel'))
    allow(TestModel).to receive(:all).and_return(scope)
    allow(scope).to receive(:to_json).and_return('[]')
    allow(Queries::Sort).to receive(:call).with(scope, sort_key: anything, sort_direction: anything).and_return(scope)

    controller = Class.new(ActionController::API) do
      include Sortable

      def index
        test_models = sort(TestModel.all)
        render json: test_models.to_json, status: :ok
      end
    end
    stub_const('MockController', controller)

    Rails.application.routes.disable_clear_and_finalize = true

    Rails.application.routes.draw { get 'mock_sort_action' => 'mock#index' }
  end
  after { Rails.application.reload_routes! }

  describe 'GET #index' do
    let(:params) { {} }
    subject(:request) { get '/mock_sort_action', params: }

    context 'when no sortable fields are defined' do
      it 'returns status code 200' do
        request
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when sortable fields are defined' do
      before do
        MockController.sortable_by :email, 'users.created_at' => 'signed_up_at', updated_at: 'last_updated_at'
      end

      let(:sort_direction) { %w[asc desc asc_nulls_first asc_nulls_last desc_nulls_first desc_nulls_last].sample }

      context 'when passing non mapped sort names' do
        let(:params) { { sort_key: :email, sort_direction: } }

        it 'returns status code 200' do
          request
          expect(response).to have_http_status(:ok)
          expect(Queries::Sort).to have_received(:call).with(scope, sort_key: 'email', sort_direction:)
        end
      end

      context 'when passing mapped sort names' do
        let(:params) { { sort_key: 'signed_up_at', sort_direction: } }

        it 'returns status code 200' do
          request
          expect(response).to have_http_status(:ok)
          expect(Queries::Sort).to have_received(:call).with(scope, sort_key: 'users.created_at', sort_direction:)
        end
      end

      context 'when sort_direction is not passed' do
        let(:params) { { sort_key: 'last_updated_at' } }

        it 'returns status code 200' do
          request
          expect(response).to have_http_status(:ok)
          expect(Queries::Sort).to have_received(:call).with(scope, sort_key: 'updated_at', sort_direction: :desc)
        end
      end

      context 'when a non existing sort key is passed' do
        let(:params) { { sort_key: 'non_existing_key' } }

        it 'raises an ActionController::BadRequest error' do
          expect { request }.to raise_error(ActionController::BadRequest)
        end
      end
    end
  end
end
