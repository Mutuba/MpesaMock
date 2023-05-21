# frozen_string_literal: true

# To deliver this notification:
#
# MpesaTransactionNotification.with(post: @post).deliver_later(current_user)
# MpesaTransactionNotification.with(post: @post).deliver(current_user)

# class MpesaTransactionNotification
class MpesaTransactionNotification < Noticed::Base
  deliver_by :database

  param :mpesa_transaction

  def message
    "#{params[:mpesa_transaction].transaction_code} Confirmed. Ksh #{params[:mpesa_transaction].amount} sent to #{params[:mpesa_transaction].receiver.phone_number}."
  end

  def url
    mpesa_transaction_details_path(params[:mpesa_transaction])
  end

  # deliver_by :email, mailer: "UserMailer"
end
