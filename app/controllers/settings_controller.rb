class SettingsController < ApplicationController
  # GET /settings/1/edit
  before_action :signed_in_user

  def edit
    @settings = Settings.find(params[:id])
  end


  # PATCH/PUT /settings/1
  def update
    @settings = Settings.find(params[:id])
    if @settings.update_attributes(settings_params)
      flash[:success] = "Settings were successfully updated."
      redirect_to edit_setting_path(@settings)
    else
      render action: 'edit'
    end
  end


  private
    # Only allow a trusted parameter "white list" through.
    def settings_params
      params[:settings]
    end
end
