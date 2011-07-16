class AddUtcToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :utc, :decimal, :default => false
  end

  def self.down
    remove_column :users, :utc
  end
end
