class AddTokenToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :token, :string
  end

  def self.down
    remove_column :sites, :token
  end
end
