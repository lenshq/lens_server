module NavigationHelper
  def navigation_element(title, path, options = {})
    current = current_page?(path)

    content_tag :li, class: (current ? :active : '') do
      link_to title, path, options
    end
  end
end
