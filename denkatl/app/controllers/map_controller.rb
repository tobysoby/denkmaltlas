class MapController < ApplicationController
  def index
  	@lats = Map.pluck(:lat)
  	@lngs = Map.pluck(:lng)
  end
end
