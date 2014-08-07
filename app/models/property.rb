class Property < ActiveRecord::Base
  
  # Relations
  has_many :property_employees, inverse_of: :property
  has_many :employees, through: :property_employees
  has_many :titles, through: :property_employees

  accepts_nested_attributes_for :property_employees

  # Paperclip
  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  # Validates
  validates_presence_of :address, :city, :state, :zip

end
