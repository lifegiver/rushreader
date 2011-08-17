class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.text    :custom_css
      t.string  :domain_name
      t.integer :domain_id
      t.integer :user_id
      t.string  :user_name
      t.text    :rule
      t.text    :title_rule

      t.timestamps
    end
  end
end
