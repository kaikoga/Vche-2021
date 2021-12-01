module EventHelper
  def event_icon_tag(event, size: :medium)
    return tag.span

    class_name = size ?  "event__icon -#{size}" : 'event__icon'
    size_num = icon_size_num(size)

    image_tag('/event_128x128.png', class: class_name,  width: size_num, height: size_num, alt: event.name, title: event.fullname)
  end

  def capacity_and_follow_text(event)
    if event.capacity > 0
      "#{event.audiences.count} / #{event.capacity} (#{event.backstage_members.count})"
    else
      "#{event.audiences.count} (#{event.backstage_members.count})"
    end
  end
end
