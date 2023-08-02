# frozen_string_literal: true

module Nameable
  extend ActiveSupport::Concern

  class_methods do
    def human_name
      model_name.human.titleize
    end
  end
end
