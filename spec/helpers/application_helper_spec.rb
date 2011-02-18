require 'spec_helper'

describe ApplicationHelper do

  describe "#navigation" do
    it "puts the block inside a <ul> within <nav>" do
      html = helper.navigation { "Home" }
      html.should == "<nav><ul>Home</ul></nav>"
    end
  end

  describe "#navigate_to" do
    it "generates a link inside an <li> tag" do
      html = helper.navigate_to(:home, "Home", "/")
      html.should == "<li>" + link_to("Home", "/") + "</li>"
    end

    it "it adds the class 'active' when the page is active " do
      @navigation_id = :home
      html = helper.navigate_to(:home, "Home", "/")
      html.should == "<li>" + link_to("Home", "/", :class => "active") + "</li>"
    end

    it "respects existing classes" do
      html = helper.navigate_to(:home, "Home", "/", :class => "large")
      html.should == "<li>" + link_to("Home", "/", :class => "large") + "</li>"

      html = helper.navigate_to(:home, "Home", "/", :class => ["large"])
      html.should == "<li>" + link_to("Home", "/", :class => "large") + "</li>"

      @navigation_id = :home
      expected_link = link_to("Home", "/", :class => "large active")
      html = helper.navigate_to(:home, "Home", "/", :class => "large")
      html.should == "<li>#{expected_link}</li>"
    end
  end

  describe "#body_id" do
    it "identifies the page from its controller and actions names" do
      helper.stub :controller_name => "posts"
      helper.stub :action_name => "show"
      helper.body_id.should == "posts_show"
    end
  end

end
