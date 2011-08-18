class User < ActiveRecord::Base
  attr_accessor :password, :article_ids
  attr_accessible :email, :password, :password_confirmation

  has_many :user_articles
  has_many :articles, :through => :user_articles, :class_name => 'Article', :source => :article, :conditions => ['user_articles.read = ?',true]
  has_one :setting

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 

  validates :email, :presence => true,
                    #:format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :confirmation => true

  before_save :encrypt_password
  after_save :update_articles
  after_create :initial_settings

  #after_save callback to handle article_ids
  def update_articles
    unless article_ids.nil?
      self.user_articles.each do |u|
        u.destroy unless article_ids.include?(u.article_id.to_s)
        article_ids.delete(u.article_id.to_s)
      end 
      article_ids.each do |a|
        self.user_articles.create(:article_id => a) unless a.blank?
      end
      reload
      self.article_ids = nil
    end
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user =find_by_email(email)
    if (user && user.encrypted_password.nil?)
      user
    else
      (user && user.has_password?(submitted_password)) ? user : nil
    end 
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end  

  private

    def initial_settings
      initial_settings = Setting.new(:utc => "London", :interval_between_readings => 25, :time_for_reading => 5, :user_id => self.id)
      self.setting = initial_settings
    end 

    def encrypt_password
      if !new_record?
        self.salt = make_salt 
        self.encrypted_password = encrypt(self.password)
      end    
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
  
    def make_salt
       secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

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
#

