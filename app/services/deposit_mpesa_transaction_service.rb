# frozen_string_literal: true

class DepositMpesaTransactionService < ApplicationService
  attr_reader :amount, :sender, :success, :error

  def initialize(params)
    @amount = params[:amount].to_i
    @sender = params[:sender]
  end

  def call
    ActiveRecord::Base.transaction do
      mpesa_transaction = create_transaction
      update_balance(mpesa_transaction)
      mark_transaction_completed(mpesa_transaction)

      OpenStruct.new(success: true, error: false)
    rescue StandardError => e
      ActiveRecord::Base.connection.rollback_db_transaction
      OpenStruct.new(success: false, error: e.message)
    end
  end

  private

  def create_transaction
    MpesaTransaction.create!(amount: @amount, sender: @sender, receiver: @sender)
  end

  def update_balance(transaction)
    mpesa_account = sender&.mpesa_account
    mpesa_account.update!(available_balance: mpesa_account.available_balance.to_f + transaction.amount.to_f)
  end

  def mark_transaction_completed(transaction)
    transaction.update!(complete: true)
  end
end