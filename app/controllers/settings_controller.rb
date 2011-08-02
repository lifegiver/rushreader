class SettingsController < ApplicationController

  before_filter :authenticate, :only => [:index, :new, :create, :update, :destroy]

  def index
    @user = current_user
    @setting = @user.setting

#    array_iterator = 1
#    @settings_array = Array.new
#    @tmp1 = Array.new
#    @tmp2 = Array.new
#    while array_iterator <= 3 do
#      @tmp1 = APP_CONFIG['array'+"#{array_iterator}"]
#      
#      @tmp1.each_with_index do |item, index|     
#        @tmp2[index] = [item, index]
#  
#      end
#      @settings_array[array_iterator] = @tmp2
#      logger.info "========================="
#      logger.info "#{array_iterator} => #{@settings_array[array_iterator]}"
#      logger.info "========================="
#      
#      array_iterator+=1
#    end

    @interval_between_readings = APP_CONFIG['interval_between_readings']
    @interval_between_readings_out = Array.new
    @interval_between_readings.each_with_index do |item, index|
      @interval_between_readings_out[index] = [item, index]
    end

    @time_for_reading = APP_CONFIG['time_for_reading']
    @time_for_reading_out = Array.new
    @time_for_reading.each_with_index do |item, index|
      @time_for_reading_out[index] = [item, index]
    end
  end

  def new
    @setting = Setting.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @setting }
    end
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(params[:setting])
		@setting.user = current_user
    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
        format.json { render json: @setting, status: :created, location: @setting }
      else
        format.html { render action: "new" }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /settings/1
  # PUT /settings/1.json
  def update
    #@setting = Setting.find(params[:id])
		@user = current_user
		@setting = @user.setting
    respond_to do |format|
      if @setting.update_attributes(params[:setting])
        format.html { redirect_to '/settings', notice: 'Setting was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy

    respond_to do |format|
      format.html { redirect_to settings_url }
      format.json { head :ok }
    end
  end

  private

    def authenticate
      deny_access unless signed_in?
    end
end

