class Page

  def self.find(hash, year=Date.today.year)
    document = Mongo.db["page_counts"].find_one(:h => hash)
    new(document)
  end

  def initialize(document)
    @document = document
  end

end
