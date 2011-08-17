class AddTitleRuleToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :title_rule, :text
  end
end
