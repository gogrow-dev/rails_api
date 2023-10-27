# frozen_string_literal: true

require 'rails_helper'

FactoryBot.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    it 'is valid' do
      factory = build(factory_name)
      expect(factory).to be_valid
    end
  end
end
