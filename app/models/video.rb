class Video
  include ActiveModel::Model

  attr_accessor :etag, :video_id, :published_at, :title, :description, :thumbnails, :channel_title

  class << self
    def from_api_hash(api_hash)
      Video.new(
        etag: api_hash['etag'],
        video_id: api_hash['id']['videoId'],
        published_at: api_hash['snippet']['publishedAt'],
        title: api_hash['snippet']['title'],
        description: api_hash['snippet']['description'],
        thumbnails: api_hash['snippet']['thumbnails'],
        channel_title: api_hash['snippet']['channelTitle']
      )
    end

    def videos_from_api(api_array)
      videos = []
      api_array.each do |api_hash|
        videos << Video.from_api_hash(api_hash)
      end
      videos
    end
  end
end