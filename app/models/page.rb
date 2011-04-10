class Page
  include ChartData
  include HashLookupHelper

  delegate :time_zone, :to => :site

  def self.find(hash, year=Date.today.year)
    if document = Mongo.db["page_counts"].find_one(:h => hash)
      new(document)
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def initialize(document)
    @document = document
  end

  def uri
    @document["u"]
  end
  
  def site
    Site.where(:token => @document["s"].to_s).first
  end

end
