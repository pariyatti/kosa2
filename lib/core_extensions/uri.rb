# frozen_string_literal: true
require 'uri'
require 'open-uri'

# NOTE: we're just re-opening URI, so it doesn't require include/extend in monkey_patches.rb
module URI

  def self.open_with_retries(url, retries=3)
    return URI.open(url)
  rescue Net::OpenTimeout => e
    # NOTE: we don't have access to 'logger' here
    puts "ERROR: timed out while trying to connect #{e}. Retrying #{retries} more times..."
    raise if retries <= 1
    self.open_with_retries(url, retries - 1)
  end

end
