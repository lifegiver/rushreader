class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.text    :custom_css
      t.string  :domain_name
      t.integer :user_id
      t.string  :user_name

      t.timestamps
    end
  end
end
