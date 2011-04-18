require "spec_helper"

describe Page do

  let :site do
    Factory :site, :time_zone => "Helsinki"
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
      Mongo.db["page_counts"].insert(
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
end
