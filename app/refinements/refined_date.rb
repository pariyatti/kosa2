# frozen_string_literal: true

module RefinedDate
  refine Date do

    # NOTE: ActiveSupport's DateAndTime::Calculations.days_since is useful
    #       but we prefer this to ensure we're operating on integer results.
    def whole_days_since(earlier)
      (self.to_date - earlier.to_date)
        .then {|day_fraction| day_fraction.to_i.abs }
    end
  end
end
