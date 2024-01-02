# frozen_string_literal: true
using RefinedDate

module RefinedDateTime
  refine DateTime do

    # NOTE: ActiveSupport's DateAndTime::Calculations.days_since is useful
    #       but we prefer this to ensure we're operating on integer results.
    def whole_days_since(earlier)
      self.to_date.whole_days_since(earlier)
    end
  end
end
