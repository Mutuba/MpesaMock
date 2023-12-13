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
require 'rails_helper'

RSpec.describe MpesaAccount, type: :model do
  describe 'Associations' do
    it { should belong_to :user }
    it { should validate_presence_of :user_id }
    it { is_expected.to respond_to :user }
  end

  describe 'Validations' do
    subject { build(:mpesa_account) }
    it { is_expected.to allow_value(0.0).for(:available_balance) }
  end
end
