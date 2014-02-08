class Settings
  include MongoMapper::Document
  key :city,					String
  key :country,					String
  key :logoURL,					String, :default => "railsgirls-logo.png"
  key :baseURL,					String, :default => "http://0.0.0.0:3000"
  key :frontPageSlogan,			String, :default => "Welcome to Rails Girls"
  key :frontPageDescription,		String, :default =>"You can register for the following workshops:"
end
