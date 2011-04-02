class Sensor < ActiveRecord::Base

  belongs_to :site

  validates_presence_of :name, :site

end
