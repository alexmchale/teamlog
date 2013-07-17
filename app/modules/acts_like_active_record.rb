module ActsLikeActiveRecord

  module InstanceMethods
    def initialize(attributes = {})
      attributes.each do |key, value|
        instance_variable_set "@#{key}", value
      end
    end

    def persisted?
      false
    end
  end

  module ClassMethods
  end

  def self.included(base)
    base.send :include, ActiveModel::Conversion
    base.send :extend, ActiveModel::Naming

    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end

end
