class PagesController < ApplicationController

  def show
    @page = Page.find(params[:id])
  end

  def find
    uri = Snowfinch::Collector.sanitize_uri(params[:page][:uri])
    uri_hash = Snowfinch::Collector.hash_uri(uri)

    redirect_to page_path(uri_hash)
  end

end
