# frozen_string_literal: true

# SendMoneyMpesaTransactionService class
class SendMoneyMpesaTransactionService < ApplicationService
  attr_reader :amount, :receiver, :sender, :success, :error

  def initialize(params)
    @amount = params[:amount].to_i
    @receiver = params[:receiver]
    @sender = params[:sender]
    @sender_account = params[:sender]&.mpesa_account
    @receiver_account = params[:receiver]&.mpesa_account
  end

  def call
    ActiveRecord::Base.transaction do
      validate_sender_balance

      # Create MpesaTransaction
      mpesa_transaction = create_transaction
      update_sender_balance(mpesa_transaction)
      update_receiver_balance(mpesa_transaction)
      mark_transaction_completed(mpesa_transaction)

      OpenStruct.new(success: true, error: false)
    rescue StandardError => e
      ActiveRecord::Base.connection.rollback_db_transaction
      OpenStruct.new(success: false, error: e.message)
    end
  end

  private

  def validate_sender_balance
    raise StandardError, 'Insufficient funds to complete transaction' if (@sender_account.available_balance.to_i.zero? ||
      @amount > @sender_account.available_balance.to_i)
  end

  def create_transaction
    MpesaTransaction.create!(amount: @amount, sender: @sender, receiver: @receiver)
  end

  def update_sender_balance(transaction)
    @sender_account.update!(available_balance: @sender_account.available_balance.to_f - transaction.amount.to_f)
  end

  def update_receiver_balance(transaction)
    @receiver_account.update!(available_balance: @receiver_account.available_balance.to_f + transaction.amount.to_f)
  end

  def mark_transaction_completed(transaction)
    transaction.update!(complete: true)
  end
end
