module EventMemoryHelper
  def event_memory_icon_tag(account, size: :medium)
    class_name = size ? "event_memory__icon -#{size}" : 'event_memory__icon'
    size_num = icon_size_num(size)

    image_tag('/event_memory_128x128.png', class: class_name, width: size_num, height: size_num, alt: EventMemory.model_name.human, title: EventMemory.model_name.human)
  end
end
