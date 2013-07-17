module ApplicationHelper

  def present(object, klass = nil, &block)
    objects = [ object ].flatten.compact
    klass ||= "#{objects.first.class.name}Presenter".constantize if objects.present?

    raw(objects.map do |object|
      presenter = klass.new(object, self)
      capture { block.call presenter }
    end.join)
  end

end
