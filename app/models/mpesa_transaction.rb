# frozen_string_literal: true

# class MpesaTransaction
class MpesaTransaction < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  before_create :auto_generate_transaction_ref

  after_create_commit :notify_sender
  after_create_commit :notify_receiver

  has_noticed_notifications

  validates :amount, numericality: {
    in: 1..300_000,
    only_integer: false,
    message: '%{value} must be between 1 and 300'
  }

  def notify_sender
    return if complete.nil?

    MpesaTransactionNotification.with(mpesa_transaction: self).deliver_later(sender)
  end

  def notify_receiver
    return if sender.id == receiver.id
    return if complete.nil?

    MpesaTransactionNotification.with(mpesa_transaction: self).deliver_later(receiver)
  end

  def auto_generate_transaction_ref
    self.transaction_code = SecureRandom.uuid.split('-')[-1].upcase
  end
end
