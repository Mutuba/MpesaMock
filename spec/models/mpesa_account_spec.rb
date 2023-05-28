# frozen_string_literal: true

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
