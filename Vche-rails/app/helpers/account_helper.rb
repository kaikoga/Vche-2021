module AccountHelper
  def account_icon_tag(account, size: :medium)
    class_name = size ? "account__icon -#{size}" : 'account__icon'
    size_num = icon_size_num(size)

    image_tag('/account_128x128.png', class: class_name, width: size_num, height: size_num, alt: account.display_name, title: account.display_name)
  end
end
