require "spec_helper"

describe Sensor do

  it { should have_many(:hosts) }
  it { should belong_to(:site) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:type) }

  let(:site) { Factory :site }
  let(:sensor_counts_collection) { Mongo.db["sensor_counts"] }

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

  let :social_media do
    sensor = Factory :sensor,
                     :site => site,
                     :type => "referrer"
    Factory(:sensor_host, :host => "facebook.com", :sensor => sensor)
    Factory(:sensor_host, :host => "twitter.com", :sensor => sensor)
    sensor
  end

  describe "#save" do
    it "syncs the sensor data with MongoDB" do
      campaign

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 1
      sensors.should include({
        "id" => campaign.id,
        "type" => "query",
        "key" => "campaign",
        "value" => "fr11"
      })

      newsletter

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 2
      sensors.should include({
        "id" => newsletter.id,
        "type" => "query",
        "key" => "from",
        "value" => "newsletter"
      })

      social_media

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 3
      sensors.should include({
        "id" => social_media.id,
        "type" => "referrer",
        "hosts" => ["facebook.com", "twitter.com"]
      })

      campaign.uri_query_value = "fr12"
      campaign.save!

      sensors = Mongo.db["sites"].find_one(site.bson_id)["sensors"]
      sensors.count.should == 3
      sensors.should include({
        "id" => campaign.id,
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
        "id" => campaign.id,
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

  describe "nested attributes for hosts" do
    it "rejects empty hosts" do
      sensor = Sensor.new
      sensor.hosts_attributes = {
        "1" => { "host" => "google.com" },
        "2" => { "host" => "   " }
      }

      sensor.hosts.length.should == 1
    end

    it "rejects duplicates" do
      sensor = Sensor.new
      sensor.hosts_attributes = {
        "1" => { "host" => "google.com" },
        "2" => { "host" => "google.com" }
      }

      sensor.hosts.length.should == 1
    end
  end

  describe "#chart_data" do
    let(:sensor) { Factory :sensor, :site => site }

    it "contains today's entries" do
      Timecop.freeze(Time.utc(2011, 7, 2, 12))

      sensor_counts_collection.insert({
        "s" => site.bson_id, "y" => 2011, "id" => sensor.id,
        "7" => { "2" => { "10" => { "c" => 20 }, "12" => { "c" => 60 } } }
      })

      expected = 16.times.map { |i| [i, 0] }
      expected[10][1] = 20
      expected[12][1] = 60

      sensor.chart_data[:today].should == expected
    end

    it "contains yesterday's entries" do
      Timecop.freeze(Time.utc(2011, 7, 2, 12))

      sensor_counts_collection.insert({
        "s" => site.bson_id, "y" => 2011, "id" => sensor.id,
        "7" => { "1" => { "14" => { "c" => 15 }, "19" => { "c" => 30 } } }
      })

      expected = 24.times.map { |i| [i, 0] }
      expected[14][1] = 15
      expected[19][1] = 30

      sensor.chart_data[:yesterday].should == expected
    end
  end

  describe "#time_zone" do
    it "returns the time zone of the site" do
      sensor = Factory :sensor, :site => site
      sensor.time_zone.should == sensor.site.time_zone
    end
  end

end
