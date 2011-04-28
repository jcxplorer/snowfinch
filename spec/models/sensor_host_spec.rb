require "spec_helper"

describe SensorHost do

  before do
    Factory :sensor_host
  end

  it { should belong_to(:sensor) }
  it { should validate_presence_of(:host) }
  it { should validate_uniqueness_of(:host).scoped_to(:sensor_id) }

end
