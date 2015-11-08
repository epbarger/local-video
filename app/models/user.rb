class User < ActiveRecord::Base
  attr_accessor :videos

  def videos
    unless @videos.present?
      videos = get_videos
    end
  end

  private

  def get_videos
    if lat && lng
      conn = ::Faraday.new(:url => ENV['YOUTUBE_BASE_URL']) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      unparsed_google_response = conn.get '', { key: ENV['GOOGLE_API_KEY'],
                                                part: 'snippet',
                                                location: "#{lat},#{lng}",
                                                locationRadius: '1mi',
                                                order: 'date',
                                                type: 'video'
                                              }
      google_response = JSON.parse(unparsed_google_response.body)
      Video.videos_from_api(google_response['items'])
    else
      []
    end
  end

  class << self
    def random
      count = User.where.not(address: nil).count
      result = ActiveRecord::Base.connection.execute("SELECT id FROM users WHERE address IS NOT NULL OFFSET floor(random()*#{count}) LIMIT 1;")
      User.find(result.first['id'])
    end
  end
end