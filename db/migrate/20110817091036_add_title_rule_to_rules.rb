class AddTitleRuleToRules < ActiveRecord::Migration
  def change
    add_column :rules, :title_rule, :text
  end
end
