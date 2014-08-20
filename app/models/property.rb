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
  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "building_placeholder.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  # Validates
  validates_presence_of :address, :city, :state, :zip

  scope :with_employees, -> { includes(:property_employees).includes(:employees) }

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

  def picture_thumb
    picture.url(:thumb)
  end

  def picture_medium
    picture.url(:medium)
  end

  def city_state_zip
    "#{city}, #{state}, #{zip}"
  end

  def titles_and_suggested_tips
    PropertyEmployee.where(property_id: self.id).pluck(:title).uniq.zip(
    PropertyEmployee.where(property_id: self.id).pluck(:suggested_tip))
  end

  def unit
    property_tenants.where(property_id: self.id).first.unit
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
