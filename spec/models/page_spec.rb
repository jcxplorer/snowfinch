require "spec_helper"

describe Page do

  let :site do
    Factory :site, :time_zone => "Helsinki"
  end

  let :page_counts do
    Mongo.db["page_counts"]
  end

  describe "#site" do
    it "is the site of the page" do
      page = Page.new("s" => site.bson_id)
      page.site.should == site
    end
  end

  describe "#time_zone" do
    it "is the time zone of the associated site" do
      page = Page.new("s" => site.bson_id)
      page.time_zone.should == "Helsinki"
    end
  end

  describe "#[]" do
    it "delegates to the document" do
      page = Page.new("a" => "A", "b" => "B")
      page["a"].should == "A"
      page["b"].should == "B"
    end
  end

  describe "#uri" do
    it "returns the value for the 'u' key" do
      page = Page.new("u" => "URI")
      page.uri.should == "URI"
    end
  end

  describe "#hash" do
    let(:page) { Page.new("h" => "HASH") }

    it "returns the value for the 'h' key" do
      page.hash.should == "HASH"
    end

    it "is aliased as #to_param" do
      page.to_param.should == "HASH"
    end
  end

  describe ".find" do
    before do
      page_counts.insert(
        :h => "HASH", :s => site.bson_id, :y => 2011
      )
    end

    it "returns a Page object for a given site, hash and year" do
      page = Page.find(site, "HASH", 2011)
      page["s"].should == site.bson_id
      page["h"].should == "HASH"
      page["y"].should == 2011
    end

    it "raises an ActiveRecord::RecordNotFound when no document is found" do
      lambda {
        Page.find(site, "FOOBAR")
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#counter_data" do
    before do
      page_counts.insert({
        "s" => site.bson_id,
        "h" => "HASH",
        "y" => 2011,
        "3" => { "4" => { "c" => 50 } }
      })

      page_counts.insert({
        "s" => site.bson_id,
        "h" => "FOO",
        "y" => 2011,
        "3" => { "4" => { "c" => 25 } }
      })
    end

    it "contains the total pageviews for the current day" do
      page_counts.insert({
        "s" => site.bson_id,
        "h" => "HASH",
        "y" => 2011,
        "3" => { "4" => { "c" => 50 } }
      })

      page = Page.find(site, "HASH", 2011)

      Timecop.freeze(Time.utc(2011, 3, 4, 12))
      page.counter_data[:pageviews_today].should == 50

      Timecop.freeze(Time.utc(2011, 1, 1))
      page.counter_data[:pageviews_today].should == 0
    end

    it "contains the number of active visitors" do
      visits = Mongo.db["visits"]

      visits.insert({
        "s" => site.bson_id,
        "p" => ["HASH"],
        "h" => Time.new(2011, 11, 11, 11, 45).to_i
      })

      visits.insert({
        "s" => site.bson_id,
        "p" => ["FOO"],
        "h" => Time.new(2011, 11, 11, 11, 50).to_i
      })

      visits.insert({
        "s" => site.bson_id,
        "p" => ["HASH", "FOO"],
        "h" => Time.new(2011, 11, 11, 11, 55).to_i
      })

      page_hash = Page.find(site, "HASH", 2011)
      page_foo  = Page.find(site, "FOO", 2011)

      Timecop.freeze(Time.new(2011, 11, 11, 12))
      page_hash.counter_data[:active_visitors].should == 1
      page_foo.counter_data[:active_visitors].should == 2
    end
  end

  describe "#chart_data" do
    it "contains today's pageviews" do
      Timecop.freeze(Time.utc(2011, 6, 8, 12))

      page_counts.insert({
        "s" => site.bson_id, "y" => 2011, "h" => "CDT",
        "6" => { "8" => { "7" => { "c" => 100 }, "10" => { "c" => 300 } } }
      })

      expected = 16.times.map { |i| [i, 0] }
      expected[7][1] = 100
      expected[10][1] = 300

      page = Page.find(site, "CDT", 2011)
      page.chart_data[:today].should == expected
    end

    it "contains yesterday's pageviews" do
      Timecop.freeze(Time.utc(2011, 12, 7, 14))

      page_counts.insert({
        "s" => site.bson_id, "y" => 2011, "h" => "CDY",
        "12" => { "6" => { "3" => { "c" => 20 }, "6" => { "c" => 10 } } }
      })

      expected = 24.times.map { |i| [i, 0] }
      expected[3][1] = 20
      expected[6][1] = 10

      page = Page.find(site, "CDY", 2011)
      page.chart_data[:yesterday].should == expected
    end
  end

end
