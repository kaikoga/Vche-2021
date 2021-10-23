module UserHelper
  def user_icon_tag(user, size: :medium)
    class_name = size ? "user__icon -#{size}" : 'user__icon'
    size_num = icon_size_num(size)

    image_tag('/user_128x128.png', class: class_name, width: size_num, height: size_num, alt: user.display_name, title: user.display_name)
  end
end
