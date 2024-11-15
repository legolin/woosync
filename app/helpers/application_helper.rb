require 'pagy/extras/bootstrap'

module ApplicationHelper
  include Pagy::Frontend

  def nav_link_item caption, path, nav_slug
    content_tag :li, class: 'nav-item' do
      link_to caption, path, class: "nav-link text-white #{@nav_slug == nav_slug ? "active" : ''}"
    end
  end

end
