class SensorsController < ApplicationController

  respond_to :html

  def index
    @site = Site.find(params[:site_id])
    @sensors = @site.sensors
    respond_with @sensors
  end
  
end
