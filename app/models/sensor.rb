class Sensor < ActiveRecord::Base

  has_many :hosts, :class_name => "SensorHost"
  belongs_to :site

  accepts_nested_attributes_for :hosts, :reject_if => proc { |attributes|
    attributes["host"].strip.empty?
  }
  validates_associated :hosts

  validates_presence_of :name, :site, :type
  validates_presence_of :uri_query_key, :uri_query_value, :if => :query_based?

  after_save :sync_with_mongodb
  after_destroy :sync_with_mongodb

  self.inheritance_column = nil

  alias_method :hosts_attributes_with_duplicates=, :hosts_attributes=
  def hosts_attributes=(attributes)
    attributes.each do |key, attr|
      attributes.delete(key) if attributes.select { |k,v| v == attr }.count > 1
    end
    self.hosts_attributes_with_duplicates = attributes
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

end
