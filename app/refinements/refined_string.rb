# frozen_string_literal: true

module RefinedString
  refine String do
    def trim
      self.gsub(/\u00A0$/, "")
          .gsub(/^\u00A0/, "")
          .strip
    end
  end
end
