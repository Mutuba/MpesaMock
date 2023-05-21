# frozen_string_literal: true

# ServiceWorkersController
class ServiceWorkersController < ApplicationController
  def service_worker
    Rails.logger.info 'service_worker is available'
  end
end
