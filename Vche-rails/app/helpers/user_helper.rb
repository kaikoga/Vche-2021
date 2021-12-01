module UserHelper
  def user_icon_tag(user, size: :medium)
    return nil unless user
    class_name = size ? "user__icon -#{size}" : 'user__icon'
    size_num = icon_size_num(size)

    image_url = user.icon_url.presence || '/user_128x128.png'
    image_tag(image_url, class: class_name, width: size_num, height: size_num, alt: user.display_name, title: user.display_name)
  end
end
