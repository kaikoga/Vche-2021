module EventHelper
  def event_icon_tag(event, size: '48px')
    image_tag('/event_128x128.png', height: size, width: size, alt: event.name, title: event.fullname)
  end
end
