module AcceptanceMatchers
  
  def has_title?(title)
    has_css?("h1", :text => title)
  end

  def has_active_navigation?(link_text)
    has_css?("body > header nav a.active", :text => link_text)
  end

  def has_notice?(text)
    has_css?("#flash", :text => text)
  end

end

Capybara::Node::Base.send :include, AcceptanceMatchers
