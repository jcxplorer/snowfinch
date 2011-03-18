class AddTypeAndQueryFieldsToSensors < ActiveRecord::Migration
  def self.up
    add_column :sensors, :type, :string
    add_column :sensors, :uri_query_key, :string
    add_column :sensors, :uri_query_value, :string
  end

  def self.down
    remove_column :sensors, :uri_query_value
    remove_column :sensors, :uri_query_key
    remove_column :sensors, :type
  end
end
