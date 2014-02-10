class MailTemplatesController < ApplicationController

  before_action :set_mail_template, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user

  # GET /mail_templates/1/edit
  def edit
  end


  # PATCH/PUT /mail_templates/1
  # PATCH/PUT /mail_templates/1.json
  def update
    @mail_template = MailTemplate.find_by_id(params[:id])
    if @mail_template.update_attributes(mail_template_params)
      flash[:success] = "Workshop was successfully updated."
      redirect_to edit_workshop_path(@mail_template.workshop)
    else
      render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mail_template
      @mail_template = MailTemplate.find(params[:id])
    end

    def signed_in_user
      store_location
      unless signed_in?
        flash[:success] = "Only for Admins available! Please sign in."
        redirect_to admin_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mail_template_params
      params[:mail_template]
    end
end
