class SensorsController < ApplicationController

  respond_to :html

  navigation :sites

  def index
    @site = Site.find(params[:site_id])
    @sensors = @site.sensors
    respond_with @sensors
  end

  def show
    @site = Site.find(params[:site_id])
    @sensor = @site.sensors.find(params[:id])
    respond_with @sensor
  end

  def new
    @site = Site.find(params[:site_id])
    @sensor = @site.sensors.new
    respond_with @sensor
  end

  def create
    @site = Site.find(params[:site_id])
    if @sensor = @site.sensors.create(params[:sensor])
      flash.notice = %{"#{@sensor.name}" has been created.}
    end
    respond_with [@site, @sensor]
  end
  
end
