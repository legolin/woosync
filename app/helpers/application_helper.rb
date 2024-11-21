require 'pagy/extras/bootstrap'

module ApplicationHelper
  include Pagy::Frontend

  def nav_link_item caption, path, nav_slug, icon = nil
    content_tag :li, class: 'nav-item' do
      link_to path, class: "nav-link text-white #{@nav_slug == nav_slug ? "active" : ''}" do
        concat(content_tag(:i, '', class: "bi bi-#{icon}")) if icon
        concat(caption)
      end
    end
  end

end
