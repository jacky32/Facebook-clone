class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :notification

  def show
    render formats: :turbo_stream, template: 'notifications/show'
  end

  def destroy
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = 'Notification deleted!' } if @notification.destroy
    end
  end

  private

  def notification
    @notification ||= Notification.find(params[:id])
  end
end
