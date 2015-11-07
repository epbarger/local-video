class VideosController < ApplicationController
  def index
    @user = get_or_create_user(session[:user_id])
    if @user.lat && @user.lng

      conn = ::Faraday.new(:url => ENV['YOUTUBE_BASE_URL']) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      unparsed_google_response = conn.get '', { key: ENV['GOOGLE_API_KEY'],
                                                part: 'snippet',
                                                location: "#{@user.lat},#{@user.lng}",
                                                locationRadius: '1mi',
                                                order: 'date',
                                                type: 'video'
                                              }
      @google_response = JSON.parse(unparsed_google_response.body)
      @videos = Video.videos_from_api(@google_response['items'])
    end
  end
end