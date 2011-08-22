class AddOriginalCreatedAtRuleToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :original_created_at_rule, :text
  end
end
