class Article < ActiveRecord::Base
  #before_save :set_updated_at
  after_create  :define_domain

  belongs_to :user
  belongs_to :domain

  def to_param
    "#{id}-#{link.parameterize}"
  end


  private

  def set_updated_at
    #articles_quantity = APP_CONFIG['articles_quantity']
    today_articles = user.articles.where(:updated_at => Time.now.midnight .. (Time.now.midnight + 1.day)).count
    if today_articles <= articles_quantity[user.setting.articles_quantity]
      self.updated_at = Time.now
    else
      self.updated_at = Time.now + 1.day
    end
  end

  def define_domain
    domain_regex = /([a-z0-9\-]*\.)+[a-z]*/i
    domain_name = self.link.match(domain_regex)[0]
    domain_find_by_name = Domain.find_by_name(domain_name)
    if domain_find_by_name.nil?
      domain = Domain.create(:name => domain_name)
      self.domain_id = domain.id
    else
      self.domain_id = domain_find_by_name.id
    end
    self.save
  end



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

