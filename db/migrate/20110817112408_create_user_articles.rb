class CreateUserArticles < ActiveRecord::Migration
  def change
    create_table :user_articles do |t|
      t.integer :user_id
      t.integer :article_id
      t.boolean :read, :default => false

      t.timestamps
    end
  end
end
