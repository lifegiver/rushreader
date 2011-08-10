class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :password, :password_confirmation

  after_create :initial_settings

  has_many :articles
  has_one :setting

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 

  validates :email, :presence => true,
                    #:format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :confirmation => true

  before_save :encrypt_password

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
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

