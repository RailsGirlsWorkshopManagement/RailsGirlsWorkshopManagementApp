class Settings
  include MongoMapper::Document
  key :city,					String
  key :country,					String
  key :logoURL,					String, :default => "railsgirls-logo.png"
  key :baseURL,					String, :default => "http://0.0.0.0:3000"
  key :frontPageSlogan,			String, :default => "Welcome to Rails Girls"
  key :frontPageDescription,	String, :default =>"You can register for the following workshops:"
  key :email_host,				String, :default =>"smtp.gmail.com"
  key :email_port,				Integer, :default =>587
  key :email_user_name,			String, :default => "railsgirlsmanagement@gmail.com"
  key :email_password,			String, :default => "hsdfajklw4jkhl213!"
  key :email_authentication,	String, :default =>"plain"
end
