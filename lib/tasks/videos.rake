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

  end
end
