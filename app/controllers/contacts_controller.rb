# frozen_string_literal: true

# MpesaUsersController
class ContactsController < ApplicationController
  before_action :authenticate_user!


  def index
    @users = User.all
  end


  def search
    @users = if params[:query].present?
               User.search_by_name_email_phone_number(params[:query])
             else
               User.all
             end

    render template: 'contacts/search', locals: { users: @users }
  end

  
  def mutuba
    render template: 'contacts/mutuba'
  end
end
