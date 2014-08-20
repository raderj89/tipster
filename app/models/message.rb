class Message
  include ActiveModel::Model

# Attribute Accessors
  attr_accessor :name, :email, :content, :address, :city, :state, :zip, :property_id

  # Validations
  validates_presence_of :name, :content
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, with: VALID_EMAIL_REGEX 
  validates_length_of :content, maximum: 500

  # Methods

  def initialize( attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

end