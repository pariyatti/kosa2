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
      Video.dump_latest_spreadsheet!(Rails.root.join('tmp', 'vimeo_latest.xlsx'))
    end

    desc "Force embed visibility to 'public'"
    task visible: [:environment] do
      puts "Downloading all video metadata first (this takes a few minutes)..."
      Video.force_all_public_embeds
    end

    desc "Update videos with categories and tags from XLSX"
    task update_from_xlsx: [:environment] do
      xlsx_path = Rails.root.join('tmp', 'vimeo_latest_with_categories.xlsx')
      Video.update_from_xlsx(xlsx_path)
    end

    desc "Sanity check: verify categories and tags were updated on Vimeo"
    task sanity_update_from_xlsx: [:environment] do
      puts "Downloading latest Vimeo metadata and generating fresh spreadsheet..."
      Video.dump_latest_spreadsheet!(Rails.root.join('tmp', 'vimeo_latest_sanity.xlsx'))

      fresh_xlsx_path = Rails.root.join('tmp', 'vimeo_latest_sanity.xlsx')
      original_xlsx_path = Rails.root.join('tmp', 'vimeo_latest_with_categories.xlsx')

      Video.sanity_check_xlsx(fresh_xlsx_path, original_xlsx_path)
    end

  end
end
