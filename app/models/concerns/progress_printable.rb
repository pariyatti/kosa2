# frozen_string_literal: true

module ProgressPrintable
  extend ActiveSupport::Concern

  class_methods do

    def print_progress(x)
      print x
      STDOUT.flush
    end

  end
end
