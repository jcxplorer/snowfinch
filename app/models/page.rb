class Page
  include TimeInTimeZone
  include HashLookupHelper

  delegate :time_zone, :to => :site
  delegate :[], :to => :@document

  def self.find(site, hash, year=Date.today.year)
    document = Mongo.db["page_counts"].find_one(:h => hash, :s => site.bson_id)

    if document
      new(document)
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def initialize(document)
    @document = document
  end

  def uri
    self["u"]
  end

  def hash
    self["h"]
  end
  alias_method :to_param, :hash
  
  def site
    Site.where(:token => self["s"].to_s).first
  end

  def counter_data
    {
      :pageviews_today => pageviews_today,
      :active_visitors => active_visitors
    }
  end

  def chart_data
    {
      :today => chart_pageviews_for_date(today),
      :yesterday => chart_pageviews_for_date(today-1)
    }
  end

  private

  def chart_pageviews_for_date(date)
    month = date.mon.to_s
    day   = date.day.to_s

    page = Mongo.db["page_counts"].find_one(
      { "s" => site.bson_id, "y" => date.year, "u" => uri },
      { :fields => ["#{month}.#{day}"] }
    )

    hours = date == today ? time_now.hour + 1 : 24

    hours.times.map do |hour|
      count = hash_lookup(page, month, day, hour.to_s, "c") || 0
      [hour, count]
    end
  end
  
  def pageviews_today
    month = today.mon.to_s
    day   = today.day.to_s

    page = Mongo.db["page_counts"].find_one(
      { "s" => site.bson_id, "y" => today.year, "u" => uri },
      { :fields => ["#{month}.#{day}.c"] }
    )

    hash_lookup(page, month, day, "c") || 0
  end

  def active_visitors
    min_heartbeat = Time.now.to_i - 15 * 60
    spec = {
      "s" => site.bson_id,
      "h" => { :$gt => min_heartbeat },
      "p" => hash
    }
    Mongo.db["visits"].find(spec).count
  end
end
