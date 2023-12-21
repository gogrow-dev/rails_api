# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Paginate do
  let(:scope) { double('scope') }
  let(:metadata) do
    double('metadata',
           page: 1,
           pages: 1,
           count: 10,
           next: nil,
           prev: nil)
  end

  before do
    allow_any_instance_of(Pagy::ArelExtra).to receive(:pagy_arel).and_return([metadata, scope])
  end

  describe '#call' do
    subject(:paginate) { described_class.call(scope, page:, per_page:) }

    context 'when page is not present' do
      let(:page) { nil }

      context 'when per_page is not present' do
        let(:per_page) { nil }

        it 'paginates the scope with default page and per_page' do
          expect_any_instance_of(Pagy::ArelExtra).to receive(:pagy_arel).with(scope, items: 10, page: 1)

          paginate
        end
      end

      context 'when per_page is present' do
        let(:per_page) { 20 }

        it 'paginates the scope with the given per_page' do
          expect_any_instance_of(Pagy::ArelExtra).to receive(:pagy_arel).with(scope, items: per_page, page: 1)

          paginate
        end
      end

      context 'when per_page is greater than MAX_PER_PAGE' do
        let(:per_page) { 200 }

        it 'paginates the scope with the given per_page' do
          expect_any_instance_of(Pagy::ArelExtra).to receive(:pagy_arel).with(scope, items: 100, page: 1)

          paginate
        end
      end
    end

    context 'when page is present' do
      let(:page) { 2 }

      context 'when per_page is not present' do
        let(:per_page) { nil }

        it 'paginates the scope with default per_page' do
          expect_any_instance_of(Pagy::ArelExtra).to receive(:pagy_arel).with(scope, items: 10, page:)

          paginate
        end
      end

      context 'when per_page is present' do
        let(:per_page) { 20 }

        it 'paginates the scope with the given per_page' do
          expect_any_instance_of(Pagy::ArelExtra).to receive(:pagy_arel).with(scope, items: per_page, page:)

          paginate
        end
      end
    end
  end
end
