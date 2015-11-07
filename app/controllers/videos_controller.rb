class VideosController < ApplicationController
  def index
    @user = get_or_create_user(session[:user_id])
    @videos = @user.videos
    @previous_user = User.random
  end
end