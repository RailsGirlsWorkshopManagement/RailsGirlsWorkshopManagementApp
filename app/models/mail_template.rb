class MailTemplate
  include MongoMapper::Document

  key :name, 	String, :default =>"standard confirmation mail template"
  key :subject, String, :default =>"Thank you for registering at the Rails Girls Workshop"
  key :text, 	String, :default =>"Dear [registration_firstname],\n\nThank you for registering for the following Rails Girls Workshop:\n\nWorkshop Name: [workshop_name]\nWorkshop Description: [workshop_description]\nDate: [workshop_date]\nVenue: [workshop_venue]\n\nSince there are only limited places available, you will receive another E-Mail whether you are accepted or not.\n\n To cancel you Registration, please visit the following link: [cancelation_link]\n\nThanks for the interest and have a great day!\n\nYour Rails Girls Team"
  belongs_to :workshop

  timestamps!

  def filter_text(registration)
	pseudo_tags = {
		"[workshop_name]" => self.workshop.name,
		"[workshop_description]" => self.workshop.description,
		"[workshop_date]" => self.workshop.date.to_s,
		"[workshop_venue]" => self.workshop.venue
	}

	if registration
		pseudo_tags["[registration_firstname]"] = registration.firstname
		pseudo_tags["[registration_lastname]"] = registration.lastname
		pseudo_tags["[cancelation_link]"] = Rails.application.routes.url_helpers.cancel_url(registration, host: ApplicationController.helpers.settings.baseURL)
	end

	print pseudo_tags

	result = self.text

	pseudo_tags.each do |key, value|
		result.gsub! key, value
	end
	result
  end
end
