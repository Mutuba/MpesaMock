# frozen_string_literal: true

# spec/services/deposit_mpesa_transaction_service_spec.rb
require 'rails_helper'

RSpec.describe DepositMpesaTransactionService do
  let(:sender) { create(:user) }
  let(:params) { { amount: 100, sender: sender } }

  describe '#call' do
    context 'when the transaction is successful' do
      it 'creates a new MpesaTransaction' do
        expect do
          described_class.new(params).call
        end.to change(MpesaTransaction, :count).by(1)
      end

      it 'updates the sender\'s available balance' do
        sender = create(:user)

        expect do
          described_class.new(params.merge(sender: sender)).call
        end.to change { sender.mpesa_account.reload.available_balance }.by(100)
      end

      it 'returns a success status' do
        result = described_class.new(params).call

        expect(result.success).to be true
        expect(result.error).to be nil
      end
    end

    context 'when an error occurs' do
      it 'returns a failure status with the error message' do
        error_message = 'Something went wrong'
        allow_any_instance_of(described_class)
          .to receive(:create_transaction)
          .and_raise(StandardError, error_message)

        result = described_class.new(params).call

        expect(result.success).to be false
        expect(result.error).to eq(error_message)
      end
    end
  end
end
