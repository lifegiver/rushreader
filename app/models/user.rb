class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :initial_settings

  has_many :articles
  has_one :setting

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :setting_attributes

  accepts_nested_attributes_for :setting

  private

    def initial_settings
      initial_settings = Setting.new(:articles_quantity => 0, :interval_between_readings => 0, :time_for_reading => 0, :user_id => self.id)
      self.setting = initial_settings
    end

end
