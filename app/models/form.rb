class Form
  include MongoMapper::Document
  many :registrations, :as => :form

  key :structure,		Object
  belongs_to :workshop
  
  timestamps!

end
