class RemoveReadFromArticles < ActiveRecord::Migration
  def up
    remove_column :articles, :read
  end

  def down
    add_column :articles, :read, :boolean
  end
end
