# frozen_string_literal: true

# == Schema Information
#
# Table name: mpesa_accounts
#
#  id                :uuid             not null, primary key
#  available_balance :decimal(8, 2)    default(0.0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_mpesa_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class MpesaAccount < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
end
