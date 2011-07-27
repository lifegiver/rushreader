class AddDomainIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :domain_id, :integer
  end
end
