class DepositMpesaTransactionService < ApplicationService

  attr_reader :amount, :receiver, :sender, :mpesa_account, :success, :error

  def initialize(params)
    @amount = params[:amount]
    @receiver = params[:receiver]
    @sender = params[:sender]
    @mpesa_account = params[:mpesa_account]
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        # Create MpesaTransaction
        transaction = MpesaTransaction.create!(amount: @mount, sender: @sender, receiver: @receiver)
        # Update mpesa balance
        existing_balance = @mpesa_account.available_balance.to_f
        new_balance = existing_balance + transaction.amount.to_f
        mpesa_account.update!(available_balance: new_balance)
        OpenStruct.new(success: true, error: false)
    rescue StandardError => e
      OpenStruct.new(success: false, error: e.message)
    end
  end
end
end