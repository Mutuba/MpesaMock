# frozen_string_literal: true

# To deliver this notification:
#
# MpesaTransactionNotification.with(post: @post).deliver_later(current_user)
# MpesaTransactionNotification.with(post: @post).deliver(current_user)

# class MpesaTransactionNotification handles sending notifications to self
class MpesaTransactionNotification < Noticed::Base
  deliver_by :database

  param :mpesa_transaction

  def message
    transaction = params[:mpesa_transaction]
    "#{transaction.transaction_code} Confirmed. Ksh #{transaction.amount} sent to self."
  end

  # deliver_by :email, mailer: "UserMailer"
end
