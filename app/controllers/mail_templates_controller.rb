class MailTemplatesController < ApplicationController

  before_action :set_mail_template, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:index, :edit, :update, :show]

  # GET /mail_templates/1/edit
  def edit
  end


  # PATCH/PUT /mail_templates/1
  # PATCH/PUT /mail_templates/1.json
  def update
    @mail_template = MailTemplate.find_by_id(params[:id])
    if @mail_template.update_attributes(mail_template_params)
      redirect_to edit_workshop_path(@mail_template.workshop), notice: 'Workshop was successfully updated.'
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
      redirect_to admin_path, notice: "Only for Admins available! Please sign in." unless signed_in?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mail_template_params
      params[:mail_template]
    end
end
