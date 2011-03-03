class Site < ActiveRecord::Base

  validates_presence_of :name, :time_zone

  before_create :create_mongo_site

  def time_zone_id
    ActiveSupport::TimeZone::MAPPING[time_zone]
  end

  private

  def create_mongo_site
    self.token = Mongo.db["sites"].insert({ :tz => time_zone_id }).to_s
  end

end
