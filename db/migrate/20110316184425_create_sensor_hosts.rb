class CreateSensorHosts < ActiveRecord::Migration
  def self.up
    create_table :sensor_hosts do |t|
      t.string :host
      t.integer :sensor_id
    end

    add_index :sensor_hosts, :sensor_id
  end

  def self.down
    drop_table :sensor_hosts
  end
end
