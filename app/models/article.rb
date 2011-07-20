class Article < ActiveRecord::Base
  before_create :can_create_article

  belongs_to :user

  private

  def can_create_article

    articles_quantity = APP_CONFIG['array1']
    today_articles = user.articles.where(:created_at => Time.now.midnight .. (Time.now.midnight + 1.day)).count
        logger.info "========================="
logger.info "today_articles = #{today_articles} articles_quantity[user.setting.articles_quantity]= #{articles_quantity[user.setting.articles_quantity]}"
logger.info "========================="
    if today_articles < articles_quantity[user.setting.articles_quantity]
      return true
    else
      return false
    end
  end

end
