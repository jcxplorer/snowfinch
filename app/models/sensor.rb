class Sensor < ActiveRecord::Base

  has_many :hosts, :class_name => "SensorHost"
  belongs_to :site

  validates_presence_of :name, :site
  validates_presence_of :uri_query_key, :uri_query_value, :if => :query_based?

  after_save :sync_with_mongodb
  after_destroy :sync_with_mongodb

  self.inheritance_column = nil

  private

  def sync_with_mongodb
    sensors = site.sensors.all.map do |sensor|
      {
        "type" => "query",
        "key" => sensor.uri_query_key,
        "value" => sensor.uri_query_value
      }
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
