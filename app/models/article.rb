class Article < ActiveRecord::Base

  has_many :user_articles
  has_many :users, :through => :user_articles
  has_many :popular_articles
  belongs_to :domain

  validates :link, :uniqueness => { :case_sensitive => false }

  after_create :define_domain

  #scope :most_popular, joins(:user_articles)
     # .where('user_articles.article_id = (SELECT MAX(user_articles.count) FROM books WHERE user_articles.article_id = articles.id)')

  def to_param
    "#{id}-#{link.parameterize}"
  end

  private

# From each new added article is cutted off its domain defined by regular expression. This domain stores
# for further editing rules of displaying articles hosted on this domain.
  def define_domain
    #domain_regex = /([a-z0-9\-]*\.)+[a-z]*/i
    domain_regex = /[^w{3}^\.^\/]([a-z0-9\-]*\.)+[a-z]*/i
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
#  id                  :integer         not null, primary key
#  link                :string(255)
#  title               :string(255)
#  domain_id           :integer
#  created_at          :datetime
#  updated_at          :datetime
#  original_created_at :datetime
#

