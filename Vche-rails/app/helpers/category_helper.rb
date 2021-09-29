module CategoryHelper
  def inline_category_tag(category)
    tag.span class: 'inline -category' do
      category.emoji_name
    end
  end
end
