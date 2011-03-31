class PagesController < ApplicationController

  def find
    uri = Snowfinch::Collector.sanitize_uri(params[:uri])
    uri_hash = Snowfinch::Collector.hash_uri(uri)

    redirect_to :action => :show, :id => uri_hash
  end

end
