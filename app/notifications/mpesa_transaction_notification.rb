# frozen_string_literal: true

# To deliver this notification:
#
# MpesaTransactionNotification.with(post: @post).deliver_later(current_user)
# MpesaTransactionNotification.with(post: @post).deliver(current_user)

class MpesaTransactionNotification < Noticed::Base
  # Add your delivery methods
  deliver_by :database

  param :mpesa_transaction

  def message
    params[:mpesa_transaction].amount
  end

  def url
    binding.pry
    mpesa_transaction_details_path(params[:mpesa_transaction])
  end

  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"
end
