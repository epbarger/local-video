class User < ActiveRecord::Base
  attr_accessor :videos, :radius, :query

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
                                                locationRadius: radius || '2mi', # '1mi', '2mi', '5mi', '10mi', '20mi'
                                                order: 'date',
                                                type: 'video',
                                                q: query || nil
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
      if count > 0
        result = ActiveRecord::Base.connection.execute("SELECT id FROM users WHERE address IS NOT NULL OFFSET floor(random()*#{count}) LIMIT 1;")
        User.find(result.first['id'])
      else
        nil
      end
    end
  end
end