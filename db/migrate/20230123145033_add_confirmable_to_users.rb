# frozen_string_literal: true

class AddConfirmableToUsers < ActiveRecord::Migration[7.0]
  def up
    change_table :users, bulk: true do |t|
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.index :confirmation_token, unique: true
    end
    execute('UPDATE users SET confirmed_at = NOW()')
  end

  def down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
  end
end
