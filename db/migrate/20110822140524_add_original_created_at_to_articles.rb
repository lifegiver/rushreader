class AddOriginalCreatedAtToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :original_created_at, :datetime
  end
end
