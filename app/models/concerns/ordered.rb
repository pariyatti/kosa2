# frozen_string_literal: true

module Ordered
  extend ActiveSupport::Concern

  included do
    self.implicit_order_column = "created_at"
  end
end
