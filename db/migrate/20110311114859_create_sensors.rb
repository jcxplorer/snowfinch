class CreateSensors < ActiveRecord::Migration
  def self.up
    create_table :sensors do |t|
      t.string :name
      t.integer :site_id

      t.timestamps
    end

    add_index :sensors, :site_id
  end

  def self.down
    drop_table :sensors
  end
end
