# frozen_string_literal: true

module Upsertable
  extend ActiveSupport::Concern

  class_methods do
    def create_or_update!(by, record)
      created = 0
      updated = 0
      e = nil
      existing = self.where({by => record[by]}).first
      if existing
        e = existing.update!(record.attributes.except('id').except('created_at').except('updated_at'))
        updated += 1
      else
        e = record.save!
        created += 1
      end
      [e, created, updated]
    end
  end

end
