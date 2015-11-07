class UsersController < ApplicationController
  def update_lat_lng
    user = get_or_create_user(session[:user_id])
    if params[:lat] && params[:lng]
      user.update!(lat: params[:lat], lng: params[:lng])
    end
    render json: { success: 'true' }
  end
end