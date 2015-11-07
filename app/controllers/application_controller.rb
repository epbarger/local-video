class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def get_or_create_user(user_id)
    if user_id
      User.find(user_id)
    else
      user = User.create!(ip: request.remote_ip)
      session[:user_id] = user.id
      user
    end
  end
end
