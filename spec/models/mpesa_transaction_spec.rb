# frozen_string_literal: true

# == Schema Information
#
# Table name: mpesa_transactions
#
#  id               :uuid             not null, primary key
#  amount           :decimal(8, 2)    default(0.0), not null
#  complete         :boolean          default(FALSE)
#  transaction_code :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  receiver_id      :uuid
#  sender_id        :uuid
#
# Indexes
#
#  index_mpesa_transactions_on_receiver_id  (receiver_id)
#  index_mpesa_transactions_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
# spec/models/mpesa_transaction_spec.rb
require 'rails_helper'
RSpec.describe MpesaTransaction, type: :model do
  describe 'associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:receiver).class_name('User') }
  end

  describe 'validations' do
    let!(:user) { create(:user) }
    it 'validates that :amount is a number greater than or equal to 1 and less than or equal to 300000' do
      mpesa_transaction = MpesaTransaction.new(amount: 0, sender: user, receiver: user)

      expect(mpesa_transaction).not_to be_valid
      expect(mpesa_transaction.errors[:amount]).to include('0 must be between 1 and 300,000')

      mpesa_transaction.amount = 1 # Set a valid amount

      expect(mpesa_transaction).to be_valid

      mpesa_transaction.amount = 300_000 # Set another valid amount

      expect(mpesa_transaction).to be_valid

      mpesa_transaction.amount = 300_001 # Set an amount that should be invalid

      expect(mpesa_transaction).not_to be_valid
      expect(mpesa_transaction.errors[:amount]).to include('300001 must be between 1 and 300,000')
    end
  end

  describe 'callbacks' do
    describe 'before_create' do
      it 'auto-generates transaction reference' do
        mpesa_transaction = FactoryBot.build(:mpesa_transaction, transaction_code: nil)
        mpesa_transaction.save

        expect(mpesa_transaction.transaction_code).not_to be_nil
      end
    end

    describe 'after_commit' do
      let(:mpesa_transaction) { FactoryBot.create(:mpesa_transaction, complete: true) }

      it 'notifies the sender' do
        expect(mpesa_transaction).to receive(:notify_sender)
        mpesa_transaction.run_callbacks(:commit)
      end

      it 'notifies the receiver' do
        expect(mpesa_transaction).to receive(:notify_receiver)
        mpesa_transaction.run_callbacks(:commit)
      end
    end
  end

  describe 'methods' do
    let(:mpesa_transaction) do
      FactoryBot.create(
        :mpesa_transaction,
        complete: true
      )
    end
    let(:user) { FactoryBot.create(:user) }

    let(:top_up_mpesa_transaction) do
      FactoryBot.create(
        :mpesa_transaction,
        complete: true,
        sender: user,
        receiver: user
      )
    end

    describe '#notify_sender' do
      context 'when sender is same as receiver' do
        it 'sends a notification to the sender if complete' do
          expect(MpesaTransactionNotification).to receive(:with)
            .with(mpesa_transaction: top_up_mpesa_transaction).and_return(double(deliver_later: true))
          top_up_mpesa_transaction.notify_sender
        end
      end

      context 'when sender and receiver are not the same' do
        it 'sends a notification to the sender if complete' do
          expect(SenderMpesaTransactionNotification).to receive(:with)
            .with(mpesa_transaction: mpesa_transaction).and_return(double(deliver_later: true))
          mpesa_transaction.notify_sender
        end
      end

      it 'does not send a notification to the sender if complete is nil' do
        mpesa_transaction.complete = nil
        top_up_mpesa_transaction.complete = nil

        expect(MpesaTransactionNotification).not_to receive(:with)
        expect(SenderMpesaTransactionNotification).not_to receive(:with)
        mpesa_transaction.notify_sender
        top_up_mpesa_transaction.notify_sender
      end
    end

    describe '#notify_receiver' do
      it 'sends a notification to the receiver if complete and sender is not the receiver' do
        expect(ReceiverMpesaTransactionNotification).to receive(:with)
          .with(mpesa_transaction: mpesa_transaction).and_return(double(deliver_later: true))
        mpesa_transaction.notify_receiver
      end

      it 'does not send a notification to the receiver if complete is nil' do
        mpesa_transaction.complete = nil

        expect(ReceiverMpesaTransactionNotification).not_to receive(:with)
        mpesa_transaction.notify_receiver
      end
    end

    describe '#auto_generate_transaction_ref' do
      it 'generates a transaction reference' do
        mpesa_transaction.auto_generate_transaction_ref

        expect(mpesa_transaction.transaction_code).not_to be_nil
      end
    end
  end
end
