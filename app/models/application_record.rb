class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def ApplicationRecord.lookup_key(k)
    define_singleton_method(:lookup_attr_key) do
      k
    end

    define_method(:lookup_attr_key) do
      k
    end

    define_method(:lookup_attr_value) do
      self.read_attribute(k)
    end
  end

end
