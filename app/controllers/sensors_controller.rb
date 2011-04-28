class SensorsController < ApplicationController

  respond_to :html, :except => [:chart]
  respond_to :json, :only => [:chart]

  navigation :sites

  def index
    @sensors = site.sensors
    respond_with @sensors
  end

  def show
    respond_with sensor
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
    respond_with sensor
  end

  def update
    if sensor.update_attributes(params[:sensor])
      flash.notice = %{"#{sensor.name}" has been updated.}
    end
    respond_with [site, sensor]
  end

  def destroy
    if sensor.destroy
      flash.notice = %{"#{sensor.name}" has been removed.}
    end
    respond_with [site, sensor]
  end

  def chart
    respond_with sensor.chart_data
  end

  private

  def sensor
    @sensor ||= site.sensors.find(params[:id])
  end

  def site
    @site ||= Site.find(params[:site_id])
  end
  
end
