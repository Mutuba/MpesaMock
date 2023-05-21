# frozen_string_literal: true

# class MpesaAccount
class MpesaAccount < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
end
