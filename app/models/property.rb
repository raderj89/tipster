class Property < ActiveRecord::Base

  # Callbacks
  before_save :set_full_address
  
  # Relations
  has_many :property_employees, dependent: :delete_all
  has_many :employees, through: :property_employees
  has_many :property_tenants, class_name: 'PropertyUser', foreign_key: 'property_id', dependent: :delete_all
  has_many :tenants, through: :property_tenants, source: :user

  # Nested attributes
  accepts_nested_attributes_for :property_employees

  # Paperclip
  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  # Validates
  validates_presence_of :address, :city, :state, :zip

  # Search
  searchkick 

  def search_data
    {
      name: name,
      address: address,
      full_address: full_address
    }
  end

  # Methods

  # So we can return the correct image path through JSON
  def picture_thumb
    picture.url(:thumb)
  end

  def city_state
    "#{city}, #{state}"
  end

  private

    def set_full_address
      if name.nil? || name == address 
        self.full_address = "#{address}, #{city}, #{state}, #{zip}"
      else
        self.full_address = "#{name}, #{address}, #{city}, #{state}, #{zip}"
      end
    end

end
