class RegistrationMailer < ActionMailer::Base
	def welcome_email(registration, mail_template)
		participant_email_with_name = "Rails Girls <"+ApplicationController.helpers.settings.email_user_name + ">"
		user_mails = []
		User.all.each do |user|
			user_mails.push user.email
		end
		mail_template.filter_text(registration)
		mail(
			from: ApplicationController.helpers.settings.email_user_name,
			to: participant_email_with_name,
			bcc: user_mails,
			subject: mail_template.subject,
			body: mail_template.text,
         	content_type: "text",
         	delivery_method_options: ApplicationController.helpers.delivery_options)
	end

	def manual_email(mail_template, receipments)
		participant_email_with_name = "Rails Girls <"+ ApplicationController.helpers.settings.email_user_name + ">"
		mail_template.filter_text(false)
		mail(
			from: ApplicationController.helpers.settings.email_user_name,
			to: ApplicationController.helpers.settings.email_user_name,
			bcc: receipments,
			subject: mail_template.subject,
			body: mail_template.text,
         	content_type: "text",
         	delivery_method_options: ApplicationController.helpers.delivery_options)
	end
end

