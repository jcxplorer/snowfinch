require "spec_helper"

describe Sensor do

  it { should belong_to(:site) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:site) }

end
