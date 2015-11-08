class VideosController < ApplicationController
  def index
    @user = get_or_create_user(session[:user_id])
    @user.radius = session[:radius]
    @user.query = session[:query]
    @videos = @user.try(:videos)
    @previous_user = User.random
  end
end