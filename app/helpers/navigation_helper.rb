module NavigationHelper
  def navigation_element(title, path)
    current = current_page?(path)

    content_tag :li, class: (current ? :active : '') do
      link_to title, path
    end
  end
end
