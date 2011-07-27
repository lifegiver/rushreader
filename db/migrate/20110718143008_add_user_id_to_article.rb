class AddUserIdToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :user_id, :integer, :default => false
  end

  def self.down
    remove_column :articles, :user_id
  end
end
