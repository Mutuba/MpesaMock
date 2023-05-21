# frozen_string_literal: true

class AddTransactionCodeToMpesaTransations < ActiveRecord::Migration[7.0]
  def change
    add_column :mpesa_transactions, :transaction_code, :string
  end
end
