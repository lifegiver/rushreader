class Article < ActiveRecord::Base
  before_create :can_create_article

  belongs_to :user

  private

  def can_create_article
    articles_quantity = APP_CONFIG['articles_quantity']
    today_articles = user.articles.where(:created_at => Time.now.midnight .. (Time.now.midnight + 1.day)).count
    if today_articles <= articles_quantity[user.setting.articles_quantity]
      return true
    else
      return false
    end
  end

end
