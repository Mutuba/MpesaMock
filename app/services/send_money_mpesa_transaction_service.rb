# frozen_string_literal: true

# class SendMoneyMpesaTransactionService
class SendMoneyMpesaTransactionService < ApplicationService
  attr_reader :amount, :receiver, :sender, :success, :error

  def initialize(params)
    @amount = params[:amount].to_i
    @receiver = params[:receiver]
    @sender = params[:sender]
  end

  def call
    ActiveRecord::Base.transaction do
      # Create MpesaTransaction
      sender_mpesa_account = sender&.mpesa_account
      receiver_mpesa_account = receiver&.mpesa_account

      if sender.mpesa_account.available_balance.to_i.zero? ||
         @amount > @sender.mpesa_account.available_balance.to_i

        raise StandardError, 'Insufficient funds to complete transaction'
      end

      mpesa_transaction = MpesaTransaction.create!(amount: @amount, sender: @sender, receiver: @receiver)
      # Update mpesa balance
      sender_existing_balance = sender_mpesa_account&.available_balance.to_f
      sender_balance_after_tranfer = sender_existing_balance - mpesa_transaction.amount.to_f

      # sender
      receiver_existing_balance = receiver_mpesa_account&.available_balance.to_f
      receiver_balance_after_tranfer = receiver_existing_balance + mpesa_transaction.amount.to_f

      # update respective balances
      sender_mpesa_account.update!(available_balance: sender_balance_after_tranfer)
      receiver_mpesa_account.update!(available_balance: receiver_balance_after_tranfer)
      # mark transaction completed
      mpesa_transaction.update!(complete: true)
      OpenStruct.new(success: true, error: false)
    rescue StandardError => e
      # Rollback the transaction if an error occurs
      ActiveRecord::Base.connection.rollback_db_transaction
      OpenStruct.new(success: false, error: e.message)
    end
  end
end
