class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :link
      t.boolean :read
      t.string :title

      t.timestamps
    end
  end
end
