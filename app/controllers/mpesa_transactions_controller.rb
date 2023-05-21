# frozen_string_literal: true

# class MpesaTransactionsController
class MpesaTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mpesa_account
  before_action :set_mpesa_transaction

  def index
    # @mpesa_transactions = current_user.mpesa_transactions.order(updated_at: :desc).page(params[:page])
    # render template: 'batch_metrics/batch_urls', locals: { urls: @urls, batch: @batch }
  end

  def details
    render template: 'mpesa_transactions/show'
  end

  # GET /resource/top_up
  def top_up
    render template: 'mpesa_transactions/top_up', locals: {
      mpesa_account: @mpesa_account, mpesa_transaction: @mpesa_transaction
    }
  end

  # GET /resource/deposit
  def deposit
    result = DepositMpesaTransactionService.call(
      amount: mpesa_top_up_params[:amount],
      sender: current_user,
      receiver: current_user,
      mpesa_account: @mpesa_account
    )

    respond_to do |format|
      if result.success
        format.html do
          redirect_to mpesa_transactions_top_up_url,
                      notice: 'Top up successful'
        end
      else
        format.html do
          redirect_to mpesa_transactions_top_up_url,
                      alert: result.error
        end
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

  def set_mpesa_transaction
    @mpesa_transaction = MpesaTransaction.new
  end

  def mpesa_top_up_params
    params.require(:mpesa_transaction).permit(:amount)
  end
end
