# frozen_string_literal: true

require 'roo'
require 'vimeo_me2'

module XlsxUpdatable
  extend ActiveSupport::Concern

  class_methods do
    def update_from_xlsx(xlsx_path)
      unless File.exist?(xlsx_path)
        puts "ERROR: File not found at #{xlsx_path}"
        return
      end

      puts "Reading XLSX file from #{xlsx_path}..."
      xlsx = Roo::Spreadsheet.open(xlsx_path.to_s)

      # Get header row to find column indices
      headers = xlsx.row(1)
      link_col = headers.index('Link')
      tags_col = headers.index('Tags')
      category_col = headers.index('Category')

      if link_col.nil? || tags_col.nil? || category_col.nil?
        puts "ERROR: Could not find required columns (Link, Tags, Category) in XLSX"
        puts "Found headers: #{headers.inspect}"
        return
      end

      token = Rails.application.credentials.vimeo_authenticated_token || ENV['VIMEO_API_TOKEN']
      updated_count = 0
      not_found_count = 0
      api_update_count = 0
      api_error_count = 0

      # Process each row (skip header)
      (2..xlsx.last_row).each do |row_num|
        row = xlsx.row(row_num)
        next if row.nil?

        link = row[link_col]
        tags_str = row[tags_col]
        category_str = row[category_col]

        next if link.blank?

        # Extract URI and video ID from link (e.g., "https://vimeo.com/123456789" -> "/videos/123456789")
        video_id = nil
        uri = if link.to_s.match(%r{vimeo\.com/(\d+)})
          video_id = $1
          "/videos/#{video_id}"
        else
          puts "WARN: Could not extract video ID from link: #{link}"
          next
        end

        # Find video by URI
        video = self.find_by(uri: uri)

        if video
          # Update database
          video.update!(
            tags: tags_str.to_s,
            category: category_str.to_s
          )
          updated_count += 1
          print "."

          # Update Vimeo via API
          begin
            vimeo_video = VimeoMe2::Video.new(token, video_id)

            # Build tags array: category as "category:xxx" and tags as "tag:xxx"
            vimeo_tags = []
            vimeo_tags << "category:#{category_str}" if category_str.present?

            # Split tags by comma and add each as "tag:xxx"
            if tags_str.present?
              tags_str.split(',').each do |tag|
                tag = tag.strip
                vimeo_tags << "tag:#{tag}" if tag.present?
              end
            end

            # Set tags on the video object
            vimeo_video.video['tags'] = vimeo_tags.map { |t| {'name' => t} }
            vimeo_video.update
            api_update_count += 1
          rescue => e
            api_error_count += 1
            puts "\nERROR updating Vimeo API for #{uri}: #{e.message}"
          end
        else
          not_found_count += 1
          puts "\nWARN: Video not found for URI: #{uri} (link: #{link})"
        end
      end

      puts "\n\nUpdate complete!"
      puts "Database updated: #{updated_count} videos"
      puts "Vimeo API updated: #{api_update_count} videos"
      puts "Vimeo API errors: #{api_error_count} videos"
      puts "Not found: #{not_found_count} videos"
    end
  end

end
