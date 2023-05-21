# frozen_string_literal: true

class MpesaTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mpesa_account

  def index
    # @mpesa_transactions = current_user.mpesa_transactions.order(updated_at: :desc).page(params[:page])
    # render template: 'batch_metrics/batch_urls', locals: { urls: @urls, batch: @batch }
  end

  def details
    binding.pry

    render template: 'mpesa_transactions/show'
  end

  # GET /resource/top_up
  def top_up
    @mpesa_transaction = MpesaTransaction.new
    render template: 'mpesa_transactions/top_up', locals: {
      mpesa_account: @mpesa_account, mpesa_transaction: @mpesa_transaction
    }
  end

  # GET /resource/deposit
  def deposit
    transaction = MpesaTransaction.create!(
      amount: mpesa_top_up_params[:amount],
      sender: current_user,
      receiver: current_user
    )

    existing_balance = @mpesa_account.available_balance.to_f
    new_balance = existing_balance + transaction.amount.to_f
    respond_to do |format|
      if current_user.mpesa_account.update!(available_balance: new_balance)
        format.html { redirect_to mpesa_transactions_top_up_url, notice: 'Top successful' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # POST /resource
  def send_money; end

  # GET /resource/reverse
  def reverse; end

  private

  def set_mpesa_account
    @mpesa_account = current_user&.mpesa_account
  end

  def mpesa_top_up_params
    params.require(:mpesa_transaction).permit(:amount)
  end
end
