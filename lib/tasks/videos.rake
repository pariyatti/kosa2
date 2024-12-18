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

  end
end
