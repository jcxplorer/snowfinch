class SensorHost < ActiveRecord::Base
  
  belongs_to :sensor

  validates_presence_of :host
  validates_uniqueness_of :host, :scope => :sensor_id

  after_save :sync_with_mongodb

  private

  def sync_with_mongodb
    sensor.send(:sync_with_mongodb)
  end

end
