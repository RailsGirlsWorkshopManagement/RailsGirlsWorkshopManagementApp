require 'active_support'

class WorkshopsController < ApplicationController

  before_action :set_workshop, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:new, :create, :index, :edit, :update, :show]
  # GET /workshops
  def index
    @workshops = Workshop.all
  end

  def publish
    @workshop = Workshop.find(params[:id])
    if (@workshop.participant_form != nil)
      @workshop.published = true
      @workshop.save
      redirect_to home_path, notice: 'Workshop was successfully published.'
    else
      redirect_to edit_workshop_path(@workshop), notice: 'Workshop could not be published. Please create a participant form!'
    end
  end

  def unpublish
    @workshop = Workshop.find(params[:id])
    @workshop.published = false
    @workshop.save
    redirect_to edit_workshop_path(@workshop), notice: 'Workshop was successfully unpublished.'
  end

  def addForm
    @existing_form = Form.find(params[:form_id])
    @workshop = Workshop.find(params[:id])
    if params[:type] == "coach"
      @form = CoachForm.new
      @key = SecureRandom.hex
      @workshop.update_attributes!(:coach_key => @key)
    else
      @form = ParticipantForm.new
    end
    @form.workshop = @workshop
    @form.structure = @existing_form.structure
    if @form.save
      redirect_to edit_form_path(@form), notice: 'Workshop was successfully updated.'
    else
      redirect_to edit_workshop_path(@workshop), notice: 'Could not update Workshop.'
    end
  end

  def manual_mail_show

  end

  def manual_mail_send
    mail_template = MailTemplate.create(:name => params[:name], :subject => params[:subject], :text => params[:text])
    mail_template.workshop = Workshop.find(params[:id])

    RegistrationMailer.manual_email(mail_template, get_receiptments_from_params(params)).deliver
    redirect_to edit_workshop_path(mail_template.workshop), notice: 'E-Mail was successfully sent.'
  end

  # GET /workshops/new
  def new
    @workshop = Workshop.new
  end

  # GET /workshops/1/edit
  def edit
    @forms = Form.all
    @mail_templates = MailTemplate.all
  end

  # POST /workshops
  def create
    @workshop = Workshop.new(workshop_params)
    standard_mail_template = MailTemplate.create(:workshop_id => @workshop.id)
    if @workshop.save
      redirect_to edit_workshop_path(@workshop), notice: 'Workshop was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /workshops/1
  def update
    if @workshop.update_attributes(workshop_params)
      redirect_to edit_workshop_path(@workshop), notice: 'Workshop was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /workshops/1
  def destroy
    @workshop.destroy
    redirect_to workshops_url, notice: 'Workshop was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workshop
      @workshop = Workshop.find(params[:id])
    end

    # Before filters
    def signed_in_user
      store_location
      redirect_to admin_path, notice: "Only for Admins available! Please sign in." unless signed_in?
    end

    # Only allow a trusted parameter "white list" through.
    def workshop_params
      params.require(:workshop).permit(:name, :date, :description, :venue)
    end

    def get_receiptments_from_params(params)
      workshop = Workshop.find(params['id'])
      receipments = []
      if params["admins"]
        User.all.each do |user|
          receipments.push user.email
        end
      end
      if params["participants"]
        workshop.participant_form.registrations.each do |registration|
          receipments.push registration.email
        end
      end
      if params["coach"]
        workshop.coach_form.registrations.each do |registration|
          receipments.push registration.email
        end
      end
      if params["participants_accepted"]
        workshop.participant_form.registrations.find_all_by_accepted(true).each do |registration|
          receipments.push registration.email
        end
      end
      if params["participants_rejected"]
        workshop.participant_form.registrations.all(:accepted.ne => true).each do |registration|
          receipments.push registration.email
        end
      end
      receipments
    end
end
