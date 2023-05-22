# frozen_string_literal: true

# == Schema Information
#
# Table name: mpesa_transactions
#
#  id               :uuid             not null, primary key
#  amount           :decimal(8, 2)    default(0.0), not null
#  complete         :boolean
#  transaction_code :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  receiver_id      :uuid
#  sender_id        :uuid
#
# Indexes
#
#  index_mpesa_transactions_on_receiver_id  (receiver_id)
#  index_mpesa_transactions_on_sender_id    (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (receiver_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
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
