class Site < ActiveRecord::Base

  validates_presence_of :name, :time_zone

  before_create :create_mongo_site

  def time_zone_id
    ActiveSupport::TimeZone::MAPPING[time_zone]
  end

  def counter_data
    counts = Mongo.db["site_counts"].find_one("s" => bson_id, "y" => today.year)

    if counts
      counts = CounterHash.new(counts)

      month = counts[today.mon.to_s]["c"]
      week = (today.monday..today).inject(0) do |sum, date|
        sum + counts[date.mon.to_s][date.day.to_s]["c"]
      end
      day = counts[today.mon.to_s][today.day.to_s]["c"]
    else
      day, week, month = 0, 0, 0
    end

    { "month" => month, "week" => week, "day" => day }
  end

  private

  def create_mongo_site
    self.token = Mongo.db["sites"].insert({ :tz => time_zone_id }).to_s
  end

  def bson_id
    BSON::ObjectId(token)
  end

  def today
    Time.now.in_time_zone(time_zone).to_date
  end

end
