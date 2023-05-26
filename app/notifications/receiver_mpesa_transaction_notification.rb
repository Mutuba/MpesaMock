# frozen_string_literal: true

# ReceiverMpesaTransactionNotification handles sending notifications to the receiver
class ReceiverMpesaTransactionNotification < MpesaTransactionNotification
  def message
    transaction = params[:mpesa_transaction]
    "#{transaction.transaction_code} Confirmed. Ksh #{transaction.amount} received from #{transaction.sender.phone_number}."
  end
end
