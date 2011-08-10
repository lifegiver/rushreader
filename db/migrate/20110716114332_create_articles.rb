class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :link
      t.boolean :read, :default => false
      t.string :title
      t.integer :user_id, :default => 0
      t.integer :domain_id

      t.timestamps
    end
  end
end
