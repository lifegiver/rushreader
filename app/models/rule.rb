class Rule < ActiveRecord::Base
end

# == Schema Information
#
# Table name: rules
#
#  id          :integer         not null, primary key
#  custom_css  :text
#  domain_name :string(255)
#  user_id     :integer
#  user_name   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

