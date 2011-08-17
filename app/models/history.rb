class History < ActiveRecord::Base
end

# == Schema Information
#
# Table name: histories
#
#  id          :integer         not null, primary key
#  custom_css  :text
#  domain_name :string(255)
#  domain_id   :integer
#  user_id     :integer
#  user_name   :string(255)
#  rule        :text
#  title_rule  :text
#  created_at  :datetime
#  updated_at  :datetime
#

