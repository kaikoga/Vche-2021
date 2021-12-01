module EventMemoryHelper
  def event_memory_icon_tag(event_memory, size: :medium)
    class_name = size ? "event_memory__icon -#{size}" : 'event_memory__icon'
    size_num = icon_size_num(size)

    image_tag('/event_memory_128x128.png', class: class_name, width: size_num, height: size_num, alt: EventMemory.model_name.human, title: EventMemory.model_name.human)
  end

  def visible_event_name(event_memory)
    event = event_memory.event
    if event.nil?
      '忘れられたイベント'
    elsif loyalty(event, 'events').show?
      event.name
    else
      '内緒のイベント'
    end
  end
end
