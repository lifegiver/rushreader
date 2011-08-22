class AddOriginalCreatedAtRuleToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :original_created_at_rule, :text
  end
end
