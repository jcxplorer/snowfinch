require "spec_helper"

describe Sensor do

  it { should have_many(:hosts) }
  it { should belong_to(:site) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:site) }

  let(:site) { Factory :site }

  let :campaign do
    Factory :sensor,
            :site => site,
            :type => "query",
            :uri_query_key => "campaign",
            :uri_query_value => "fr11"
  end

  let :newsletter do
    Factory :sensor,
            :site => site,
            :type => "query",
            :uri_query_key => "from",
            :uri_query_value => "newsletter"
  end

  describe "#save" do
    it "syncs the sensor data with MongoDB" do
      campaign

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 1
      sensors.should include({
        "type" => "query",
        "key" => "campaign",
        "value" => "fr11"
      })

      newsletter

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 2
      sensors.should include({
        "type" => "query",
        "key" => "from",
        "value" => "newsletter"
      })

      campaign.uri_query_value = "fr12"
      campaign.save!

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 2
      sensors.should include({
        "type" => "query",
        "key" => "campaign",
        "value" => "fr12"
      })
    end
  end

  describe "#destroy" do
    it "syncs the sensor data with MongoDB" do
      campaign
      newsletter

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 2

      newsletter.destroy

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 1
      sensors.should include({
        "type" => "query",
        "key" => "campaign",
        "value" => "fr11"
      })
    end
  end

  describe "#uri_query_key" do
    context "query based sensor" do
      it "is required" do
        sensor = Factory.build :sensor, :type => "query"
        sensor.should validate_presence_of(:uri_query_key)
      end
    end

    context "host based sensor" do
      it "is not required" do
        sensor = Factory.build :sensor, :type => "host"
        sensor.should_not validate_presence_of(:uri_query_key)
      end
    end
  end

  describe "#uri_query_value" do
    context "query based sensor" do
      it "is required" do
        sensor = Factory.build :sensor, :type => "query"
        sensor.should validate_presence_of(:uri_query_value)
      end
    end

    context "host based sensor" do
      it "is not required" do
        sensor = Factory.build :sensor, :type => "host"
        sensor.should_not validate_presence_of(:uri_query_value)
      end
    end
  end

end
