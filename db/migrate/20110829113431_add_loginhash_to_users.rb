class AddLoginhashToUsers < ActiveRecord::Migration
  def change
    add_column :users, :loginhash, :string
  end
end
