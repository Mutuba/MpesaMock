# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  phone_number           :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { described_class.new }

  describe 'Associations' do
    it { should have_many :sent_transactions }
    it { should have_many :received_transactions }
    it { should have_many :notifications }
    it { should have_one :mpesa_account }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_confirmation_of(:password) }

    it 'validates the format of phone_number' do
      user.phone_number = '12345'
      expect(user).not_to be_valid
      expect(user.errors[:phone_number]).to include('must valid')

      user.phone_number = '1234567890123456'
      expect(user).not_to be_valid
      expect(user.errors[:phone_number]).to include('must valid')
    end

    it 'validates phone_number format with no errors if valid' do
      user.phone_number = '+254724821901'
      expect(user.errors[:phone_number]).to be_empty
    end

    it 'user record is valid if all required attributes are present' do
      user.phone_number = '+254724821901'
      user.email = 'test@example.com'
      user.password = 'password'
      user.password_confirmation = 'password'
      expect(user).to be_valid
    end

    it 'user has an mpesa account after successful creation' do
      user.phone_number = '+254724821901'
      user.email = 'test@example.com'
      user.password = 'password'
      user.password_confirmation = 'password'
      user.save!

      expect(user).to be_valid
      expect(user.mpesa_account).not_to be_nil
    end
  end
end
