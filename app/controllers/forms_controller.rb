require 'json'

class FormsController < ApplicationController
  before_action :set_form, only: [:show, :edit, :update, :destroy]

  # GET /forms
  def index
    @forms = Form.all
    @workshop = Workshop.find(params[:workshop_id])
    @structure = []
    @forms.each do |form|
      @structure.push JSON.parse form.structure
    end
  end

  # GET /forms/1
  def show
  end

  # GET /forms/new
  def new
    @form = Form.new
    @structure = []
    @structure.push "type"=>"text", "caption"=>"Firstname", "name"=>"firstname", "class"=>"immutable_element"
    @structure.push "type"=>"text", "caption"=>"Lastname", "name"=>"lastname", "class"=>"immutable_element"
    @structure.push "type"=>"text", "caption"=>"E-Mail", "name"=>"email", "class"=>"immutable_element"
  end

  # GET /forms/1/edit
  def edit
  end

  # POST /forms
  def create
    workshop_id = form_params[:workshop_id]
    @workshop = Workshop.find(workshop_id)
    if form_params[:type] == "coach"
      @form = CoachForm.new(form_params)
      if @workshop != nil
        @key = SecureRandom.hex
        @workshop.update_attributes!(:coach_key => @key)
      end
    else
      @form = ParticipantForm.new(form_params)
    end
    @form.workshop_id = workshop_id
    if @form.save
      redirect_to @form, notice: 'Form was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /forms/1
  def update
    @form = Form.find_by_id(params[:id])
    if @form.update_attributes(form_params)
      redirect_to @form, notice: 'Form was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /forms/1
  def destroy
    @form.destroy
    if @form.workshop != nil
      @form.workshop.published = false
      @form.workshop.save
    end
    redirect_to :back, notice: 'Form was successfully destroyed. Due to this, the corresponding Workshop is no longer published'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def form_params
      params[:form]
    end
end
