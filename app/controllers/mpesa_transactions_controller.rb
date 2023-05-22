# frozen_string_literal: true

# class MpesaTransactionsController
class MpesaTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mpesa_account
  before_action :set_mpesa_transaction
  before_action :set_send_money_receiver_account, only: [:transfer]

  def index
    @mpesa_transactions = current_user.all_transactions.order(updated_at: :desc).page(params[:page])
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
      amount: mpesa_transaction_params[:amount],
      sender: current_user
    )
    respond_to do |format|
      if result&.success
        format.html do
          redirect_to mpesa_transactions_top_up_url,
                      notice: 'Top up was successful.'
        end
      else
        format.html do
          redirect_to mpesa_transactions_top_up_url,
                      alert: result&.error
        end
      end
    end
  end

  def transfer
    render template: 'mpesa_transactions/send_money', locals: { mpesa_transaction: @mpesa_transaction }
  end

  def send_money
    # user may change user phone number
    @receiver_account_from_form = User.find_by_phone_number(params[:mpesa_transaction][:phone_number])
    if @receiver_account_from_form.nil?
      flash[:alert] = 'Oops! Provided phone number not in the list of contacts'
      return redirect_to mpesa_transactions_transfer_path
    end

    result = SendMoneyMpesaTransactionService.call(
      amount: params[:mpesa_transaction][:amount],
      sender: current_user,
      receiver: @receiver_account_from_form
    )
    respond_to do |format|
      if result&.success
        format.html do
          redirect_to mpesa_transactions_top_up_url,
                      notice: 'Send money was successful.'
        end
      else
        format.html do
          redirect_to mpesa_transactions_top_up_url,
                      alert: result&.error
        end
      end
    end
  end

  # GET /resource/reverse
  def reverse; end

  private

  def set_mpesa_account
    @mpesa_account = current_user&.mpesa_account
  end

  def set_send_money_receiver_account
    @receiver_account = User.find_by(id: params[:id])
  end

  def set_mpesa_transaction
    @mpesa_transaction = MpesaTransaction.new
  end

  def mpesa_transaction_params
    params.require(:mpesa_transaction).permit(:amount, :phone_number)
  end
end
