class RegistrationMailer < ActionMailer::Base
	default from: 'railsgirlsmanagement@gmail.com'

	def welcome_email(registration, mail_template)
		participant_email_with_name = "#{registration.firstname} #{registration.lastname} <#{registration.email}>"
		user_mails = []
		User.all.each do |user|
			user_mails.push user.email
		end
		mail_template.filter_text(registration)
		mail(to: participant_email_with_name,
			bcc: user_mails,
			subject: mail_template.subject,
			body: mail_template.text,
         	content_type: "text")
	end

	def manual_email(mail_template, receipments)
		participant_email_with_name = "Rails Girls <railsgirlsmanagement@gmail.com>"
		mail_template.filter_text(false)
		mail(to: 'railsgirlsmanagement@gmail.com',
			bcc: receipments,
			subject: mail_template.subject,
			body: mail_template.text,
         	content_type: "text")
	end
end