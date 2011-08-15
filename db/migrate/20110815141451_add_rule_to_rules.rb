class AddRuleToRules < ActiveRecord::Migration
  def change
    add_column :rules, :rule, :text
  end
end
