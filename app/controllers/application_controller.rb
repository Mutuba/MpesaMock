# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  add_flash_types :danger, :info, :warning, :success, :messages

  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email password phone_number])
  end
end
