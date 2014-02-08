require 'net/http'
require 'uri'
require 'json'

class Registration
  include MongoMapper::Document
  plugin MongoMapper::Plugins::MultiParameterAttributes

	key :firstname,		String,		:length => { :maximum => 50 }
	key :lastname,		String,		:length => { :maximum => 50 }
	key :email,			String
	key :accepted,		Boolean,	:default => false
	key :cancled,		Boolean,	:default => false
	key :comment,		String

	timestamps!

	validates_presence_of :firstname, :lastname, :email
	# validate :custom_validation

	def custom_validation
		email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	    if validates_format_of :email, :with =>email_regex
	      errors.add( :email, "Incorrect Email")
	    end
	end
	belongs_to :form, :polymorphic => true

	def send_to_global_server
		uri =  URI('http://railsgirlsglobal.herokuapp.com/registrations')

		data = {
			'firstname' => self.firstname,
			'lastname' => self.lastname,
			'email' => self.email,
			'country' => ApplicationController.helpers.settings.country,
			'city' => ApplicationController.helpers.settings.city,
			'type' => self.form_type
		}

		response = Net::HTTP.new(uri.host, uri.port).start do |http| 
			request = Net::HTTP::Post.new(uri, {'Content-Type' =>'application/json', 'Accept' => 'application/json'})
			request.body = data.to_json

			http.request(request) 
		end

		puts "Response #{response.code} #{response.message}: #{response.body}"
	end
end