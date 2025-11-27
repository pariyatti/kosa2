# frozen_string_literal: true

namespace :kosa do
  namespace :videos do

    desc "Sync Vimeo videos to DB"
    task sync: [:environment] do
      puts "Syncing Vimeo metadata in [#{Rails.env}]... (this will take a few minutes)"
      Video.sync_all!
    end

    desc "Truncate Video table in production"
    task prod_trunc: [:environment] do
      Video.delete_all
    end

    desc "Dump Vimeo list to XLSX"
    task xlsx: [:environment] do
      puts "Dumping Vimeo metadata in [#{Rails.env}]... (this will take a few minutes)"
      Video.dump_latest_spreadsheet!
    end

    desc "Force embed visibility to 'public'"
    task visible: [:environment] do
      puts "Downloading all video metadata first (this takes a few minutes)..."
      Video.force_all_public_embeds
    end

    desc "Update videos with categories and tags from XLSX"
    task update_from_xlsx: [:environment] do
      require 'roo'

      xlsx_path = Rails.root.join('tmp', 'vimeo_latest_with_categories.xlsx')

      unless File.exist?(xlsx_path)
        puts "ERROR: File not found at #{xlsx_path}"
        exit 1
      end

      puts "Reading XLSX file from #{xlsx_path} as #{xlsx_path.class}..."
      xlsx = Roo::Spreadsheet.open(xlsx_path.to_s)

      # Get header row to find column indices
      headers = xlsx.row(1)
      link_col = headers.index('Link')
      tags_col = headers.index('Tags')
      category_col = headers.index('Category')

      if link_col.nil? || tags_col.nil? || category_col.nil?
        puts "ERROR: Could not find required columns (Link, Tags, Category) in XLSX"
        puts "Found headers: #{headers.inspect}"
        exit 1
      end

      updated_count = 0
      not_found_count = 0

      # Process each row (skip header)
      (2..xlsx.last_row).each do |row_num|
        row = xlsx.row(row_num)
        next if row.nil?

        link = row[link_col]
        tags = row[tags_col]
        category = row[category_col]

        next if link.blank?

        # Extract URI from link (e.g., "https://vimeo.com/123456789" -> "/videos/123456789")
        uri = if link.to_s.match(%r{vimeo\.com/(\d+)})
          "/videos/#{$1}"
        else
          puts "WARN: Could not extract video ID from link: #{link}"
          next
        end

        # Find video by URI
        video = Video.find_by(uri: uri)

        if video
          video.update!(
            tags: tags.to_s,
            category: category.to_s
          )
          updated_count += 1
          print "."
        else
          not_found_count += 1
          puts "\nWARN: Video not found for URI: #{uri} (link: #{link})"
        end
      end

      puts "\n\nUpdate complete!"
      puts "Updated: #{updated_count} videos"
      puts "Not found: #{not_found_count} videos"
    end

  end
end
