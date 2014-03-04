require 'json'

class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:index, :update, :destroy, :comment_registrations, :cancel, :accept_registrations]
  # GET /registrations
  # GET /registrations.json
  def index
    # prepare data for select tag filter
    @list_options = load_list_options
    @previously_selected_type = params["form_type"]

    # get workshops
    workshops = Workshop.all(:id => params["workshop"])
    if workshops.length == 0 
      if params["workshop"] == 'all'
        workshops = Workshop.all
      elsif not Workshop.last.nil?
        workshops = [Workshop.last]
      end
    end

    # get registrations for selected workshops
    registrations = []
    workshops.each do |w|
      Registration.all.each do |r| 
        if r.form
          if r.form.workshop
            registrations << r if r.form.workshop.id == w.id
          end
        end
      end
    end

    # filter registrations by type
    if params["form_type"] == "participant"
      registrations = registrations.select { |r| r.form_type == "ParticipantForm" }
    elsif params["form_type"] == "coach"
      registrations = registrations.select { |r| r.form_type == "CoachForm" }
    end

    @participant_registrations = []
    @participant_structure = nil
    @coach_registrations = []
    @coach_structure = nil

    # prepare registrations data and structure for selected workshop
    if workshops.length == 1
      @previously_selected_workshop = workshops[0].id

      # prepare participant data 
      if workshops[0].participant_form?
        filtered_data = parse_structure(workshops[0].participant_form.structure, registrations.select { |r| r.form_type == "ParticipantForm" })
        @participant_registrations = filtered_data[0]
        @participant_structure = filtered_data[1]
      end

      # prepare coach data 
      if workshops[0].coach_form?
        filtered_data = parse_structure(workshops[0].coach_form.structure, registrations.select { |r| r.form_type == "CoachForm" })
        @coach_registrations = filtered_data[0]
        @coach_structure = filtered_data[1]
      end

    # for all workshops: only prepare the immutable attributes
    else
      @participant_structure = [
        {"caption"=>"Firstname", "name"=>"firstname"},
        {"caption"=>"Lastname", "name"=>"lastname"},
        {"caption"=>"E-Mail", "name"=>"email"}
      ]

      @participant_registrations = parse_structure(@participant_structure.to_json, registrations)[0]
    end

    respond_to do |format|
        format.html
        format.csv
        format.xls
    end
  end

  # GET /registrations/new
  def new
    @registration = Registration.new
    @workshop = Workshop.find(params[:workshop_id])
    if params[:type] != 'coach'
      @form = @workshop.participant_form
    elsif params[:type] == "coach" && params[:coach_key] == @workshop.coach_key
      @form = @workshop.coach_form
    end
  end

  # GET /registrations/1/edit
  def edit
    @registration = Registration.find_by_id(params[:id])
    @form = @registration.form
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(params)
    print @registration
    @registration.form = Form.find(params[:form_id])
    print @registration.form
      if @registration.save
        # send email to participant after registration not working jet.
        workshop = @registration.form.workshop
        RegistrationMailer.welcome_email(@registration, workshop.mail_template).deliver
        flash[:success] = "Your registration was successful"
        redirect_to success_reg_path
      else
        flash[:error] = "Your registration was not successfull"
        redirect_to :back
      end
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    @registration = Registration.find_by_id(params[:id])
    if @form.update_attributes(registration_params)
      flash[:success] = "Registration was successfully updated."
      redirect_to @registration
    else
      render action: 'edit'
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { head :no_content }
    end
  end

  def comment_registrations
    # render :text => params["registration"]
    r = Registration.find(params["registration"]["id"])
    r.comment = params["registration"]["comment"];
    r.save
    redirect_to :back
  end

  def accept_registrations
    params.select{ |key, value| value == "1" }.keys.each do |id|
      r = Registration.find(id)
      if !r.accepted && r.global_data_transmission
        r.send_to_global_server
      end
      r.accepted = true
      r.save
    end
    params.select{ |key, value| value == "0" }.keys.each do |id|
      r = Registration.find(id)
      r.accepted = false
      r.save
    end
    flash[:success] = "Registrations successfully accepted."
    redirect_to :back
  end

  def cancel
    registration = Registration.find(params[:id])
    if(!registration.nil?)
      registration.cancled = true
      if(registration.save)
        render :text=>"Registration succesfully cancled"
      else
        render :text=>"Couldn't find your registration"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    def load_list_options
      workshop_options = []
      workshop_options.push(["all", "all"])
      Workshop.all.each do |workshop|
        workshop_options.push([workshop.name + " : " + workshop.date.to_s, Workshop.find(workshop.id).id])
      end
      options = {:workshop => workshop_options, :form_type => ["all", "participant", "coach"]}
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
    # params.require(:registration).permit(:firstname, :lastname, :email, :language, :last_attended, :coding_level, :os, :other_languages, :project, :idea, :want_learn, :group, :join_group, :notes)
      params
    end

    # Before filters
    def signed_in_user
      store_location
      unless signed_in?
        flash[:error] = "Only for Admins available! Please sign in."
        redirect_to admin_path
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def parse_structure(form_structure, registrations_data)
      registrations = []
      structure = JSON.parse form_structure
      hidden_keys = ["_id", "form_id", "form_type", "authenticity_token", "action", "controller"]
      registrations_data.each do |registration|
        attributes = registration.attributes.clone
        hidden_keys.each do |key|
          attributes.delete key
        end
        i = 0
        for elem in structure
          if elem["type"] == "radiobuttons"
            val = attributes[elem["name"]]
            attributes[elem["name"]] = elem["options"][val]
          end
          i += 1
        end

        reg = {}
        reg["id"] = registration.id.to_s
        reg["attributes"] = attributes
        registrations.push reg
      end
      structure_and_registration = [registrations, structure]
    end
end
