require "yaml"

module Snowfinch

  def self.configuration
    @configuration ||= begin
      yaml = File.read(Rails.root.join("config/snowfinch.yml"))
      YAML.load(yaml)[Rails.env].with_indifferent_access
    end
  end

end
