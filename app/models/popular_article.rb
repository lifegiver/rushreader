class PopularArticle < ActiveRecord::Base

  belongs_to :article

end

# == Schema Information
#
# Table name: popular_articles
#
#  id         :integer         not null, primary key
#  article_id :integer
#  views      :integer
#  created_at :datetime
#  updated_at :datetime
#

