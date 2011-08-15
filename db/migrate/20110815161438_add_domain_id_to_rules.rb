class AddDomainIdToRules < ActiveRecord::Migration
  def change
    add_column :rules, :domain_id, :integer
  end
end
