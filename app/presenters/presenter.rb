class Presenter

  def initialize(object, template)
    @object = object
    @template = template
  end

  def method_missing(name, *args, &block)
    @template.send(name, *args, &block)
  end

  def self.presents_as(name)
    define_method(name) do
      @object
    end
  end

end
