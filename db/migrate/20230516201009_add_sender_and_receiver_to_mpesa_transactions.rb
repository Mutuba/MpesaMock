# frozen_string_literal: true

class AddSenderAndReceiverToMpesaTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :mpesa_transactions, :sender, index: true, type: :uuid, foreign_key: { to_table: :users }
    add_reference :mpesa_transactions, :receiver, index: true, type: :uuid, foreign_key: { to_table: :users }
  end
end
