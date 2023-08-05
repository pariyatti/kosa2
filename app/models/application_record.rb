class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def ApplicationRecord.naturalkey_column(k)
    define_singleton_method(:naturalkey_name) do
      k
    end

    define_method(:naturalkey_name) do
      k
    end
    
    define_method(:naturalkey_value) do
      self.read_attribute(k)
    end
  end

end
