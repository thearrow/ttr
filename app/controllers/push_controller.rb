class PushController < ApplicationController
  before_filter :check_access, only: [:index, :send_notifications]
  skip_before_filter :verify_authenticity_token, :only => [:register]

  def index
    @count = DeviceToken.count
  end

  def send_notifications
    send_ios_notifications()
    send_android_notifications()
    render text: "Push Notifications Successfully Sent To #{DeviceToken.count} Devices! \nMessage: #{params[:alert]}"
  end

  # Hit from the mobile app
  # POSTs the token and type (ios or android)
  # eg. POST /push/register?token=devicetokenhere&type=ios
  def register
    token, type = params[:token], params[:type]
    if token and type
      token_class = (DeviceTokenIos if type == 'ios') || (DeviceTokenAndroid if type == 'android')
      if token_class
        token_class.find_or_create_by(token_params) ? (head :ok) : (head :internal_server_error)
        return
      end
    end
    head :bad_request, error: 'Usage: POST /push/register?token={token}&type={ios || android}'
  end

  private
  def check_access
    redirect_to '/admin' unless current_admin
  end

  def token_params
    params.permit(:token)
  end

  def send_ios_notifications
    notifications = []
    DeviceTokenIos.all.each do |token|
      notifications << APNS::Notification.new(token.token, alert: params[:alert])
    end
    APNS.send_notifications(notifications)
  end

  def send_android_notifications
    devices = DeviceTokenAndroid.all.collect { |token| token.token }
    data = {alert: params[:alert]}
    notifications = GCM::Notification.new(devices, data)
    GCM.send_notifications(notifications)
  end
end
