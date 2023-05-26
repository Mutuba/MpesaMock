# frozen_string_literal: true

# MpesaUsersController
class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, :set_mpesa_transaction, only: [:show]

  def index
    @users = User.where.not(id: current_user.id)
  end

  def search
    @users = if params[:query].present?
               User.search_by_name_email_phone_number(params[:query])
             else
               User.all
             end

    render template: 'contacts/search', locals: { users: @users }
  end

  def show
  end

  private

  def set_contact
    @contact = User.find_by(id: params[:id])
  end

  def set_mpesa_transaction
    @mpesa_transaction = MpesaTransaction.new
  end
end
