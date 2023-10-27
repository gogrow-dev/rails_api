# frozen_string_literal: true

class AddJtiMatcherToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :jti, :string, null: false, unique: true
  end
end
