class RegistrationsController < Devise::RegistrationsController

	def new
		super
	end

	def create
    super
		initial_settings = Setting.new(	:articles_quantity => 20, 
																:interval_between_readings => 25,
																:time_for_reading => 5,
																:user_id => @user.id)
		@user.setting = initial_settings
	end

	def update
		super	
	end

end
