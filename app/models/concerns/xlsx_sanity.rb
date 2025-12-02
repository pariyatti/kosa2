# frozen_string_literal: true

require 'roo'

module XlsxSanity
  extend ActiveSupport::Concern

  class_methods do
    def sanity_check_xlsx(fresh_xlsx_path, original_xlsx_path)
      unless File.exist?(fresh_xlsx_path)
        puts "ERROR: Fresh spreadsheet not found at #{fresh_xlsx_path}"
        exit 1
      end

      unless File.exist?(original_xlsx_path)
        puts "ERROR: Original spreadsheet not found at #{original_xlsx_path}"
        puts "This task expects you to have run 'update_from_xlsx' with the original file."
        exit 1
      end

      puts "Reading fresh data from Vimeo..."
      fresh_xlsx = Roo::Spreadsheet.open(fresh_xlsx_path.to_s)
      fresh_headers = fresh_xlsx.row(1)
      fresh_link_col = fresh_headers.index('Link')
      fresh_tags_col = fresh_headers.index('Tags')
      fresh_category_col = fresh_headers.index('Category')

      puts "Reading original data..."
      original_xlsx = Roo::Spreadsheet.open(original_xlsx_path.to_s)
      original_headers = original_xlsx.row(1)
      original_link_col = original_headers.index('Link')
      original_tags_col = original_headers.index('Tags')
      original_category_col = original_headers.index('Category')

      # Build a hash of expected values from the original spreadsheet
      expected = {}
      (2..original_xlsx.last_row).each do |row_num|
        row = original_xlsx.row(row_num)
        next if row.nil?

        link = row[original_link_col]
        next if link.blank?

        expected[link] = {
          tags: row[original_tags_col].to_s,
          category: row[original_category_col].to_s
        }
      end

      # Check the fresh data against expected values
      match_count = 0
      mismatch_count = 0
      missing_count = 0
      mismatches = []

      (2..fresh_xlsx.last_row).each do |row_num|
        row = fresh_xlsx.row(row_num)
        next if row.nil?

        link = row[fresh_link_col]
        next if link.blank?

        # Only check videos that were in the original update
        next unless expected.key?(link)

        fresh_tags = row[fresh_tags_col].to_s
        fresh_category = row[fresh_category_col].to_s
        expected_tags = expected[link][:tags]
        expected_category = expected[link][:category]

        # Parse fresh tags to extract the actual tag values
        fresh_tag_list = fresh_tags.split(',').map(&:strip)
          .select { |t| t.start_with?('tag:') }
          .map { |t| t.sub(/^tag:/, '') }
          .join(',')

        # Parse fresh category to extract the actual category value
        fresh_category_value = fresh_category.sub(/^category:/, '')

        # Compare
        tags_match = fresh_tag_list == expected_tags
        category_match = fresh_category_value == expected_category

        if tags_match && category_match
          match_count += 1
          print "."
        else
          mismatch_count += 1
          mismatches << {
            link: link,
            expected_tags: expected_tags,
            actual_tags: fresh_tag_list,
            expected_category: expected_category,
            actual_category: fresh_category_value
          }
        end
      end

      puts "\n\nSanity check complete!"
      puts "Matches: #{match_count} videos"
      puts "Mismatches: #{mismatch_count} videos"

      if mismatch_count > 0
        puts "\nMismatched videos:"
        mismatches.each do |m|
          puts "\n  #{m[:link]}"
          if m[:expected_tags] != m[:actual_tags]
            puts "    Tags - Expected: #{m[:expected_tags]}"
            puts "    Tags - Actual:   #{m[:actual_tags]}"
          end
          if m[:expected_category] != m[:actual_category]
            puts "    Category - Expected: #{m[:expected_category]}"
            puts "    Category - Actual:   #{m[:actual_category]}"
          end
        end
      else
        puts "\n✓ All videos have correct tags and categories on Vimeo!"
      end
    end
  end

end
