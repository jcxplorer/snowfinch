require "spec_helper"

describe Site do
  
  it { should validate_presence_of(:name) }

  describe "#time_zone_id" do
    it "returns the TZInfo indentifier" do
      site = Site.new(:time_zone => "Helsinki")
      site.time_zone_id.should == "Europe/Helsinki"
    end
  end

end
