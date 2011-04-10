class Site < ActiveRecord::Base
  include TimeInTimeZone
  include HashLookupHelper

  has_many :sensors, :dependent => :destroy

  validates_presence_of :name, :time_zone

  before_create :create_mongo_site

  def time_zone_id
    ActiveSupport::TimeZone::MAPPING[time_zone]
  end

  def counter_data
    {
      :pageviews_today => pageviews_today,
      :active_visitors => active_visitors,
      :visitors_today => visitors_today
    }
  end

  def chart_data
    {
      :today => chart_pageviews_for_date(today),
      :yesterday => chart_pageviews_for_date(today-1)
    }
  end

  def bson_id
    BSON::ObjectId(token)
  end

  private

  def create_mongo_site
    self.token = Mongo.db["sites"].insert({ :tz => time_zone_id }).to_s
  end

  def chart_pageviews_for_date(date)
    month = date.mon.to_s
    day   = date.day.to_s

    site = Mongo.db["site_counts"].find_one(
      { "s" => bson_id, "y" => date.year },
      { :fields => ["#{month}.#{day}"] }
    )

    hours = date == today ? time_now.hour + 1 : 24

    hours.times.map do |hour|
      count = hash_lookup(site, month, day, hour.to_s, "c") || 0
      [hour, count]
    end
  end

  def pageviews_today
    month = today.mon.to_s
    day   = today.day.to_s

    site = Mongo.db["site_counts"].find_one(
      { "s" => bson_id, "y" => today.year },
      { :fields => ["#{month}.#{day}.c"] }
    )

    hash_lookup(site, month, day, "c") || 0
  end

  def active_visitors
    min_heartbeat = Time.now.to_i - 15 * 60
    spec = { "s" => bson_id, "h" => { :$gt => min_heartbeat } }
    Mongo.db["visits"].find(spec).count
  end

  def visitors_today
    Mongo.db["visitors"].find("s" => bson_id, "d" => today.to_s).count
  end
end
