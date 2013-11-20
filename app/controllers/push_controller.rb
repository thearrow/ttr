class PushController < ApplicationController
  before_filter :check_access, only: [:index, :send_notifications]

  def index
    @count = Urbanairship.device_tokens_count['active_device_tokens_count']
  end

  def send_notifications
    notification = {
        :aps => { :alert => params[:alert], :badge => 1 },
        :android => { :alert => params[:alert] }
    }
    Urbanairship.broadcast_push(notification)

    render text: "Push Notifications Successfully Sent
      To #{Urbanairship.device_tokens_count['active_device_tokens_count']} Devices! \nMessage: #{params[:alert]}"
  end

  private
  def check_access
    redirect_to '/admin' unless current_admin
  end
end
