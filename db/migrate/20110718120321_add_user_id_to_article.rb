class AddUserIdToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :user_id, :integer, :default => false
  end
end
