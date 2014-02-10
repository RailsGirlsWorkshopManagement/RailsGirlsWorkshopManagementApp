module ApplicationHelper
	  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Rails Girls"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def settings
  	Settings.first || Settings.create
  end

  def delivery_options
    delivery_options = {
      user_name: self.settings.email_user_name,
      password: self.settings.email_password,
      address: self.settings.email_host,
      # port: self.settings.email_port,
      # authentication: self.settings.email_authentication
    }
  end
end
