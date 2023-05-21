# frozen_string_literal: true

# class ApplicationService
class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
