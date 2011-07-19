class SettingsController < ApplicationController

  def index
    @user = current_user
    @setting = @user.setting
  end

  def new
    @setting = Setting.new
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
end
