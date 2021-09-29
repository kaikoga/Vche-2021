module FlavorHelper
  def inline_flavor_tag(flavor)
    tag.span class: 'inline -flavor' do
      flavor.emoji_name
    end
  end

  def flavor_check_box_tag(flavor, name, id, checked)
    label_tag id, class: :flavor_tag do
      check_box_tag(name, flavor.slug, checked, id: id) + flavor.emoji + flavor.name
    end
  end
end
