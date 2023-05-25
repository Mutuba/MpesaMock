# frozen_string_literal: true

# ReceiverMpesaTransactionNotification handles sending notifications to the sender of a transaction
class SenderMpesaTransactionNotification < MpesaTransactionNotification
  deliver_by :database

  def message
    transaction = params[:mpesa_transaction]
    "#{transaction.transaction_code} Confirmed. Ksh #{transaction.amount} sent to #{transaction.receiver.phone_number}."
  end
end
