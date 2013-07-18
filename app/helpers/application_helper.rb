module ApplicationHelper

  def present(object, klass = nil, extra_attributes = {}, &block)
    if klass.kind_of?(Hash)
      extra_attributes = klass
      klass            = nil
    end

    objects = [ object ].flatten.compact
    klass ||= "#{objects.first.class.name}Presenter".constantize if objects.present?

    raw(objects.map do |object|
      presenter = klass.new(object, self)
      extra_attributes.each { |k, v| presenter.send("#{k}=", v) }
      capture { block.call presenter }
    end.join)
  end

end
