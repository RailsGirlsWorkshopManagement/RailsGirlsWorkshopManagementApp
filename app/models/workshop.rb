class Workshop
  include MongoMapper::Document
  plugin MongoMapper::Plugins::MultiParameterAttributes

  key :name,				String
  key :description,			String
  key :date,				Date
  key :venue,				String
  key :published,		Boolean, :default => false

  one :mail_template
  one :coach_form
  one :participant_form

  timestamps!
end
