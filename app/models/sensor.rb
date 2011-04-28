class Sensor < ActiveRecord::Base
  include TimeInTimeZone
  include HashLookupHelper

  has_many :hosts, :class_name => "SensorHost"
  belongs_to :site

  accepts_nested_attributes_for :hosts,
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes["host"].strip.empty? }

  validates_associated :hosts

  validates_presence_of :name, :site, :type
  validates_presence_of :uri_query_key, :uri_query_value, :if => :query_based?

  after_save :sync_with_mongodb
  after_destroy :sync_with_mongodb

  self.inheritance_column = nil

  delegate :time_zone, :to => :site

  alias_method :hosts_attributes_with_duplicates=, :hosts_attributes=
  def hosts_attributes=(attributes)
    attributes.each do |key, attr|
      attributes.delete(key) if attributes.select { |k,v| v == attr }.count > 1
    end
    self.hosts_attributes_with_duplicates = attributes
  end

  def chart_data
    {
      :today => chart_entries_for_date(today),
      :yesterday => chart_entries_for_date(today-1)
    }
  end

  private

  def sync_with_mongodb
    sensors = site.sensors.all.map do |sensor|
      case sensor.type
      when "query"
        {
          "id" => sensor.id,
          "type" => "query",
          "key" => sensor.uri_query_key,
          "value" => sensor.uri_query_value
        }
      when "referrer"
        {
          "id" => sensor.id,
          "type" => "referrer",
          "hosts" => sensor.hosts.all.map(&:host)
        }
      end
    end

    Mongo.db["sites"].update(
      { :_id => site.bson_id },
      { :$set => { "sensors" => sensors } }
    )
  end

  def query_based?
    type == "query"
  end

  def chart_entries_for_date(date)
    month = date.mon.to_s
    day   = date.day.to_s

    sensor = Mongo.db["sensor_counts"].find_one(
      { "s" => site.bson_id, "y" => date.year, "id" => id },
      { :fields => ["#{month}.#{day}"] }
    )

    hours = date == today ? time_now.hour + 1 : 24

    hours.times.map do |hour|
      count = hash_lookup(sensor, month, day, hour.to_s, "c") || 0
      [hour, count]
    end
  end
end
