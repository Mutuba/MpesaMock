# frozen_string_literal: true

# == Schema Information
#
# Table name: mpesa_transactions
#
#  id               :uuid             not null, primary key
#  amount           :decimal(8, 2)    default(0.0), not null
#  complete         :boolean          default(FALSE)
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
FactoryBot.define do
  factory :mpesa_transaction do
    amount { 250 }
    association :sender, factory: :user
    association :receiver, factory: :user
    complete { false }
  end
end
