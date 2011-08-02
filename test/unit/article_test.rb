require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: articles
#
#  id         :integer         not null, primary key
#  link       :string(255)
#  read       :boolean         default(FALSE)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer         default(0)
#  domain_id  :integer
#

