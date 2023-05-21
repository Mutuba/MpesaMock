# frozen_string_literal: true

# class User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :password, confirmation: true

  validates :phone_number, presence: true
  validate :phone_number_valid?

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
end
