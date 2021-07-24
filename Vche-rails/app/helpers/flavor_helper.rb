module FlavorHelper
  def flavor_tag(flavor)
    content_tag(:span, class: :flavor_tag) do
      flavor.emoji + flavor.name
    end
  end

  def flavor_check_box_tag(flavor, name, id, checked)
    label_tag id, class: :flavor_tag do
      check_box_tag(name, flavor.slug, checked, id: id) + flavor.emoji + flavor.name
    end
  end
end
