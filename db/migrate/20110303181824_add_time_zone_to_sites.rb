class AddTimeZoneToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :time_zone, :string
  end

  def self.down
    remove_column :sites, :time_zone
  end
end
