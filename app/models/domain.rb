class Domain < ActiveRecord::Base

  validates :name, :presence => true,
                   :uniqueness => { :case_sensitive => false }

  has_many :articles

end

# == Schema Information
#
# Table name: domains
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  rule       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  custom_css :text
#  title_rule :text
#

