class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer   :interval_between_readings
      t.integer   :time_for_reading
      t.integer   :user_id
      t.string    :utc


      t.timestamps
    end
  end
end
