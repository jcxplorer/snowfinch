require "spec_helper"

describe Site do
  
  let :site do
    Factory :site, :time_zone => "Helsinki"
  end

  let :site_counts do
    Mongo.db["site_counts"]
  end

  it { should validate_presence_of(:name) }

  describe "#time_zone_id" do
    it "returns the TZInfo indentifier" do
      site = Site.new(:time_zone => "Helsinki")
      site.time_zone_id.should == "Europe/Helsinki"
    end
  end

  describe "#bson_id" do
    it "returns a BSON::ObjectId from the token" do
      token = "4d73838feca02647cd000001"
      site = Site.new(:token => token)
      site.bson_id.should == BSON::ObjectId(token)
    end
  end
  
  describe "#counter_data" do
    it "contains the total pageviews for the current day" do
      sites = Mongo.db["site_counts"]
      sites.insert({
        "s" => site.bson_id,
        "y" => 2011,
        "1" => { "6" => { "c" => 200 } }
      })

      Timecop.freeze(Time.utc(2011, 1, 6, 12))
      site.counter_data[:pageviews_today].should == 200

      Timecop.freeze(Time.utc(2011, 1, 1))
      site.counter_data[:pageviews_today].should == 0
    end

    it "contains the number of active visits" do
      visits = Mongo.db["visits"]

      visits.insert({
        "s" => site.bson_id,
        "h" => Time.new(2011, 11, 11, 11, 45).to_i
      })

      visits.insert({
        "s" => site.bson_id,
        "h" => Time.new(2011, 11, 11, 11, 50).to_i
      })

      visits.insert({
        "s" => site.bson_id,
        "h" => Time.new(2011, 11, 11, 11, 55).to_i
      })

      Timecop.freeze(Time.new(2011, 11, 11, 12))
      site.counter_data[:active_visits].should == 2
    end

    it "contains the number of unique visitors for the current day" do
      visitors = Mongo.db["visitors"]

      visitors.insert({ "s" => site.bson_id, "u" => "A", "d" => "2011-01-01" })
      visitors.insert({ "s" => site.bson_id, "u" => "B", "d" => "2011-01-01" })
      visitors.insert({ "s" => site.bson_id, "u" => "C", "d" => "2011-01-02" })

      Timecop.freeze(Time.utc(2011, 1, 1, 12))
      site.counter_data[:visitors_today].should == 2

      Timecop.freeze(Time.utc(2010, 12, 31, 23))
      site.counter_data[:visitors_today].should == 2

      Timecop.freeze(Time.utc(2011, 1, 2))
      site.counter_data[:visitors_today].should == 1
    end
  end

  describe "#chart_data" do
    it "contains today's pageviews" do
      Timecop.freeze(Time.utc(2011, 6, 8, 12))

      site_counts.insert({
        "s" => site.bson_id, "y" => 2011,
        "6" => { "8" => { "7" => { "c" => 100 }, "10" => { "c" => 300 } } }
      })

      expected = 16.times.map { |i| [i, 0] }
      expected[7][1] = 100
      expected[10][1] = 300

      site.chart_data[:today].should == expected
    end

    it "contains yesterday's pageviews" do
      Timecop.freeze(Time.utc(2011, 12, 7, 14))

      site_counts.insert({
        "s" => site.bson_id, "y" => 2011,
        "12" => { "6" => { "3" => { "c" => 20 }, "6" => { "c" => 10 } } }
      })

      expected = 24.times.map { |i| [i, 0] }
      expected[3][1] = 20
      expected[6][1] = 10

      site.chart_data[:yesterday].should == expected
    end
  end

end
