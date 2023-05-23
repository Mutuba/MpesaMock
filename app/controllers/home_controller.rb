# frozen_string_literal: true

# HomeController controller
class HomeController < ApplicationController
  before_action :set_mpesa_account, only: %i[show]
  before_action :authenticate_user!, except: %i[index]

  def index; end

  def show
    render template: 'mpesa_transactions/mpesa_account', locals: {
      current_user: current_user, mpesa_account: @mpesa_account
    }
  end

  private

  def set_mpesa_account
    @mpesa_account = current_user&.mpesa_account
  end
end
