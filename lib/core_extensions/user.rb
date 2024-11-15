# frozen_string_literal: true
require 'vimeo_me2'

module CoreExtensions
  module VimeoMe2
    module UserMethods
      def get_full_video_list
        videos = []
        next_page = prefix_endpoint(get_video_list['paging']['first'])
        while next_page
          puts "Downloading next page: #{next_page}"
          page = get(next_page)
          page_videos = page['data'].map {|h| to_video(h) }
          videos.concat(page_videos)
          next_page = prefix_endpoint(page['paging']['next'])
        end
        videos
      end

      # NOTE: from VimeoMe2's own HttpRequest - url is tested against 'http', even in
      #       VM2 code that can't assume that yet, unfortunately.
      def prefix_endpoint endpoint
        return nil if endpoint.nil?
        /https?/.match(endpoint) ? endpoint : "https://api.vimeo.com#{endpoint}"
      end

      def to_video(h)
        v = Video.new(
          uri:              h['uri'],
          name:             h['name'],
          description:      h['description'],
          link:             h['link'],
          player_embed_url: h['player_embed_url'],
          embed_html:       h['embed_html'],
          width:            h['width'],
          height:           h['height'],
          language:         h['language'],
          duration:         h['duration'],
          created_time:     h['created_time'],
          modified_time:    h['modified_time'],
          release_time:     h['release_time'],
          privacy_view:     h['privacy']['view'],
          privacy_embed:    h['privacy']['embed'],
          privacy_download: h['privacy']['download'],
          picture_base_link: h['pictures']['base_link'],
          tags:             h['tags'].map { |t| t['name'] }, #.join(','),
          play_stats:       h['stats']['plays'],
          status:           h['status']
        )
        v.validate!
        v
      end
    end
  end
end
