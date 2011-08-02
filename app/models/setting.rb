class Setting < ActiveRecord::Base

  belongs_to :user
end

# == Schema Information
#
# Table name: settings
#
#  id                        :integer         not null, primary key
#  interval_between_readings :integer
#  time_for_reading          :integer
#  user_id                   :integer
#  utc                       :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#

