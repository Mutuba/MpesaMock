# frozen_string_literal: true

# class DepositMpesaTransactionService
class DepositMpesaTransactionService < ApplicationService
  attr_reader :amount, :receiver, :sender, :mpesa_account, :success, :error

  def initialize(params)
    @amount = params[:amount].to_i
    @receiver = params[:receiver]
    @sender = params[:sender]
    @mpesa_account = params[:mpesa_account]
  end

  def call
    ActiveRecord::Base.transaction do
      # Create MpesaTransaction       
      mpesa_transaction = MpesaTransaction.create!(amount: @amount, sender: @sender, receiver: @receiver)
      # Update mpesa balance
      existing_balance = @mpesa_account.available_balance.to_f
      balance_after_deposit = existing_balance + mpesa_transaction.amount.to_f
      mpesa_account.update!(available_balance: balance_after_deposit)
      mpesa_transaction.update!(complete: true)
      OpenStruct.new(success: true, error: false)
    rescue StandardError => e
      # Rollback the transaction if an error occurs
      ActiveRecord::Base.connection.rollback_db_transaction
      OpenStruct.new(success: false, error: e.message)
    end
  end
end
