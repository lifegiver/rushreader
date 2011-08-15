class AddCustomCssToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :custom_css, :text
  end
end
