# frozen_string_literal: true

class MpesaAccount < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
end
