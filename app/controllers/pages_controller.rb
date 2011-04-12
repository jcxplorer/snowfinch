class PagesController < ApplicationController
  respond_to :html, :except => [:counters, :chart]
  respond_to :json, :only => [:counters, :chart]

  def show
    respond_with page
  rescue ActiveRecord::RecordNotFound
    render :not_found
  end

  def find
    uri = Snowfinch::Collector.sanitize_uri(params[:page][:uri])
    uri_hash = Snowfinch::Collector.hash_uri(uri)

    redirect_to page_path(uri_hash)
  end

  def counters
    respond_with page.counter_data
  end

  def chart
    respond_with page.chart_data
  end

  private

  def page
    @page ||= Page.find(params[:id])
  end

end
