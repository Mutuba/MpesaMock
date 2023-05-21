# frozen_string_literal: true

class CreateMpesaTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :mpesa_transactions, id: :uuid do |t|
      t.decimal :amount, precision: 8, scale: 2, default: 0, null: false
      t.boolean :complete

      t.timestamps
    end
  end
end
