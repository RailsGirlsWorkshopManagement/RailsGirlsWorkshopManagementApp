class StaticPagesController < ApplicationController
  def home
  	@workshops = Workshop.find_all_by_published(true)
  end
end
