# frozen_string_literal: true

class AddFalseAsDefaultForMpesaTransactionsComplete < ActiveRecord::Migration[7.0]
  def change
    change_column :mpesa_transactions, :complete, :boolean, default: false
  end
end
