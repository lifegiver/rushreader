class Article < ActiveRecord::Base
  has_many :user_articles
  has_many :users, :through => :user_articles
  belongs_to :domain

  after_create :define_domain

  def to_param
    "#{id}-#{link.parameterize}"
  end

  private

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
#  title      :string(255)
#  domain_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

