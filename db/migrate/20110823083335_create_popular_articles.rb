class CreatePopularArticles < ActiveRecord::Migration
  def change
    create_table :popular_articles do |t|
      t.integer :article_id
      t.integer :views

      t.timestamps
    end
  end
end
