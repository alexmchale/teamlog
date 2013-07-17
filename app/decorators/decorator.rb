class Decorator < BasicObject

  undef_method :==

  def initialize(object)
    @object = object
  end

  def class
    @object.class
  end

  def method_missing(name, *args, &block)
    @object.send(name, *args, &block)
  end

  def self.decorates_as(name)
    define_method name do
      @object
    end
  end

end
