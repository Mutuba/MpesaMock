# frozen_string_literal: true

class CreateMpesaAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :mpesa_accounts, id: :uuid do |t|
      t.decimal :available_balance, precision: 8, scale: 2, default: 0, null: false
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
