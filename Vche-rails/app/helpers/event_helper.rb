module EventHelper
  def event_icon_tag(event, size: :medium)
    class_name = size ?  "event__icon -#{size}" : 'event__icon'
    size_num = icon_size_num(size)

    image_tag('/event_128x128.png', class: class_name,  width: size_num, height: size_num, alt: event.name, title: event.fullname)
  end
end
