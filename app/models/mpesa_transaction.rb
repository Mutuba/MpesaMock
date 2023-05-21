# frozen_string_literal: true

class MpesaTransaction < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  before_create :auto_generate_transaction_ref

  after_create_commit :notify_sender
  after_create_commit :notify_receiver

  has_noticed_notifications

  def notify_sender
    MpesaTransactionNotification.with(mpesa_transaction: self).deliver_later(sender)
  end

  def notify_receiver
    return if sender.id == receiver.id

    MpesaTransactionNotification.with(mpesa_transaction: self).deliver_later(receiver)
  end

  def auto_generate_transaction_ref
    self.transaction_code = SecureRandom.uuid.split("-")[-1].upcase
  end
end
