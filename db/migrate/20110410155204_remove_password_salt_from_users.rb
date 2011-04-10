class RemovePasswordSaltFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :password_salt
  end

  def self.down
  end
end
