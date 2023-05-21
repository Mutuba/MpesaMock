# frozen_string_literal: true

class MpesaTransaction < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  after_create :send_notifications

  after_create_commit :notify_sender
  after_create_commit :notify_receiver

  has_noticed_notifications

  def send_notifications
    Rails.logger.info 'notifications will be sent once configured'
  end

  def notify_sender
    MpesaTransactionNotification.with(mpesa_transaction: self).deliver_later(sender)
  end

  def notify_receiver
    MpesaTransactionNotification.with(mpesa_transaction: self).deliver_later(receiver)
  end
end
