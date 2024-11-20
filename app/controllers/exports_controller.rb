class ExportsController < ApplicationController
  before_action :set_nav_slug

  def index
  end

  private

  def set_nav_slug
    @nav_slug = :exports
  end
end
