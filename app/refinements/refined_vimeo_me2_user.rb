# frozen_string_literal: true

module RefinedVimeoMe2User
  refine VimeoMe2::User do
    def get_full_video_list
      json = {'total' => nil, 'page' => nil, 'per_page' => nil, 'paging' => nil, 'data' => []}
      next_page = prefix_endpoint(get_video_list['paging']['first'])
      while next_page
        puts "Downloading next page: #{next_page}"
        page = get(next_page)
        # mutate everything per page, but accumulate 'data' key:
        json['total'] = page['total']
        json['page'] = page['page']
        json['per_page'] = page['per_page']
        json['paging'] = page['paging']
        json['data'].concat(page['data'])
        next_page = prefix_endpoint(page['paging']['next'])
      end
      json
    end

    # NOTE: from VimeoMe2's own HttpRequest - url is tested against 'http', even in
    #       VM2 code that can't assume that yet, unfortunately.
    def prefix_endpoint(endpoint)
      return nil if endpoint.nil?
      /https?/.match(endpoint) ? endpoint : "https://api.vimeo.com#{endpoint}"
    end
  end
end
