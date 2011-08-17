class UserArticle < ActiveRecord::Base

  belongs_to :user
  belongs_to :article

end

# == Schema Information
#
# Table name: user_articles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  article_id :integer
#  read       :boolean
#  created_at :datetime
#  updated_at :datetime
#

