class SitesController < ApplicationController

  respond_to :html
  navigation :sites

  def index
    @sites = Site.order(:name)
    respond_with @sites
  end

  def show
    respond_with resource
  end

  def new
    respond_with(@site = Site.new)
  end

  def create
    @site = Site.new(params[:site])
    if @site.save
      flash.notice = %{"#{@site.name}" has been created.}
    end
    respond_with @site
  end

  def edit
    respond_with resource
  end

  def update
    if resource.update_attributes(params[:site])
      flash.notice = %{"#{resource.name}" has been updated.}
    end
    respond_with resource
  end

  def destroy
    if resource.destroy
      flash.notice = %{"#{resource.name}" has been removed.}
    end
    respond_with resource
  end

  private

  def resource
    @site ||= Site.find(params[:id])
  end

end
