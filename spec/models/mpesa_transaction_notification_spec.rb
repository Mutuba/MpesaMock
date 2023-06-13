# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MpesaTransactionNotification, type: :notification do
  let(:mpesa_transaction) { FactoryBot.create(:mpesa_transaction) }

  describe '#message' do
    it 'returns the correct message' do
      notification = MpesaTransactionNotification.new(mpesa_transaction: mpesa_transaction)
      expected_message = "#{mpesa_transaction.transaction_code} Confirmed. Ksh #{mpesa_transaction.amount} sent to self."

      expect(notification.message).to eq(expected_message)
    end
  end

  describe 'delivery' do
    it 'database is icluded as delivery method' do
      notification = MpesaTransactionNotification.new(mpesa_transaction: mpesa_transaction)
      expect(notification.delivery_methods[0][:name]).to eq(:database)
    end
  end
end
