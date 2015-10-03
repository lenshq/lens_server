module NavigationHelper
  def navigation_element(title, path)
    current = current_page?(path)
    "<li#{current ? " class='active'" : ""}>#{link_to title, path}</li>".html_safe
  end
end
