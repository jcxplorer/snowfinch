require "mongo"
require "configuration"

module Mongo

  def self.db
    @db ||= Mongo::Connection.new.db(Snowfinch.configuration["mongo_database"])
  end

end
