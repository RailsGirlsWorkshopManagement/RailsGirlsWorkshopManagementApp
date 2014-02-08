class SettingsController < ApplicationController
  # GET /settings/1/edit
  def edit
    @settings = Settings.find(params[:id])
  end


  # PATCH/PUT /settings/1
  def update
    @settings = Settings.find(params[:id])
    if @settings.update_attributes(settings_params)
      redirect_to edit_setting_path(@settings), notice: 'Settings were successfully updated.'
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