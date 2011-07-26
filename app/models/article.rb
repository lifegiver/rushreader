class Article < ActiveRecord::Base
  before_save :set_updated_at

  belongs_to :user

  private

  def set_updated_at
    articles_quantity = APP_CONFIG['articles_quantity']
    today_articles = user.articles.where(:updated_at => Time.now.midnight .. (Time.now.midnight + 1.day)).count
    if today_articles <= articles_quantity[user.setting.articles_quantity]
      self.updated_at = Time.now
    else
      self.updated_at = Time.now + 1.day
    end
  end

end
