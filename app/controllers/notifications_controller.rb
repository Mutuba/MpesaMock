# frozen_string_literal: true

# class NotificationsController
class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: %i[mark_as_read]

  def index
    @notifications = Notification.where(recipient: current_user, read_at: nil).order(created_at: :desc)
  end

  def mark_as_read
    respond_to do |format|
      if @notification.mark_as_read!
        format.html { redirect_to notifications_url, notice: 'Notification marked as read' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_notification
    @notification = Notification.find_by(id: params[:id])
  end
end
