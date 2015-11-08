class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def get_or_create_user(user_id)
    user = User.where(id: user_id).first if user_id
    user = User.where(ip: request.remote_ip, address: params[:geo]).first if !user
    if !user
      user = User.create!(ip: request.remote_ip)
      session[:user_id] = user.id
      user
    end
    user
  end
end
