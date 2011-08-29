require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#  created_at         :datetime
#  updated_at         :datetime
#  loginhash          :string(255)
#

