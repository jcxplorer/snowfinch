class Site < ActiveRecord::Base

  validates_presence_of :name, :time_zone

  before_create :create_mongo_site

  def time_zone_id
    ActiveSupport::TimeZone::MAPPING[time_zone]
  end

  def counter_data
    {
      :pageviews_today => pageviews_today,
      :active_visits => active_visits,
      :visitors_today => visitors_today
    }
  end

  def bson_id
    BSON::ObjectId(token)
  end

  private

  def create_mongo_site
    self.token = Mongo.db["sites"].insert({ :tz => time_zone_id }).to_s
  end

  def today
    Time.now.in_time_zone(time_zone).to_date
  end

  def pageviews_today
    month = today.mon.to_s
    day   = today.day.to_s

    site = Mongo.db["site_counts"].find_one(
      { "s" => bson_id, "y" => today.year },
      { :fields => ["#{month}.#{day}.c"] }
    )

    (site && site[month] && site[month][day] && site[month][day]["c"]) || 0
  end

  def active_visits
    min_heartbeat = Time.now.to_i - 15 * 60
    spec = { "s" => bson_id, "h" => { :$gt => min_heartbeat } }
    Mongo.db["visits"].find(spec).count
  end

  def visitors_today
    Mongo.db["visitors"].find("s" => bson_id, "d" => today.to_s).count
  end

end
