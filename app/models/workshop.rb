class Workshop
  include MongoMapper::Document
  plugin MongoMapper::Plugins::MultiParameterAttributes

  key :name,				  String, :required => true
  key :description,		String, :required => true
  key :date,				  Date, :required => true
  key :venue,         String, :required => true
  key :published,     Boolean, :default => false

  one :mail_template
  one :coach_form
  one :participant_form

  timestamps!
end
