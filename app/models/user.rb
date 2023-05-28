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
# class User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include PgSearch::Model
  pg_search_scope :search_by_name_email_phone_number,
                  against: %i[first_name last_name email phone_number]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, confirmation: { presence: true }

  validates :phone_number, presence: true
  validate :phone_number_valid?, if: :phone_number

  has_one :mpesa_account, dependent: :destroy
  has_many :sent_transactions, class_name: 'MpesaTransaction', foreign_key: 'sender_id'
  has_many :received_transactions, class_name: 'MpesaTransaction', foreign_key: 'receiver_id'
  has_many :notifications, as: :recipient

  after_create :create_user_with_mpesa_account

  def phone_number_valid?
    errors.add(:phone_number, 'must valid') unless self[:phone_number].match(/\A[0-9+\s\-]+\z/)

    # All phone numbers with country codes are between 8-15 characters long
    errors.add(:phone_number, 'must valid') unless self[:phone_number]
                                                   .gsub(/[^0-9]/, '')
                                                   .length.between?(8, 15)
  end

  def full_name
    [first_name, last_name].select(&:present?).join(' ').titleize
  end

  def create_user_with_mpesa_account
    MpesaAccount.create!(user_id: id)
  end

  def notifications_count
    Notification.where(recipient: self, read_at: nil).size
  end

  def total_transactions_value
    transaction_total = MpesaTransaction
                        .where('sender_id = ? OR receiver_id = ?', id, id)
                        .sum(:amount)

    transaction_total
  end

  def all_transactions
    MpesaTransaction.where('sender_id = :user_id OR receiver_id = :user_id', user_id: id)
  end
end
