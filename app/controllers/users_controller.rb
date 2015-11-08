class UsersController < ApplicationController
  def update_lat_lng
    user = get_or_create_user(nil)
    if params[:lat] && params[:lng]
      user.lat = params[:lat]
      user.lng = params[:lng]
    end
    if params[:geo]
      user.address = params[:geo]
    end
    user.save!
    session[:user_id] = user.id
    render json: { success: 'true' }
  end
end