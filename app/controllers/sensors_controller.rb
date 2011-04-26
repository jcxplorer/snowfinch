class SensorsController < ApplicationController

  respond_to :html

  navigation :sites

  def index
    @sensors = site.sensors
    respond_with @sensors
  end

  def show
    @sensor = site.sensors.find(params[:id])
    respond_with @sensor
  end

  def new
    @sensor = site.sensors.new
    respond_with @sensor
  end

  def create
    if @sensor = site.sensors.create(params[:sensor])
      flash.notice = %{"#{@sensor.name}" has been created.}
    end
    respond_with [site, @sensor]
  end

  def edit
    @sensor = site.sensors.find(params[:id])
    respond_with @sensor
  end

  def update
    @sensor = site.sensors.find(params[:id])
    if @sensor.update_attributes(params[:sensor])
      flash.notice = %{"#{@sensor.name}" has been updated.}
    end
    respond_with [site, @sensor]
  end

  private

  def site
    @site ||= Site.find(params[:site_id])
  end
  
end
