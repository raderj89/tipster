class Property < ActiveRecord::Base

  # Callbacks
  before_create :set_full_address
  
  # Relations
  has_many :property_employees, inverse_of: :property
  has_many :employees, through: :property_employees
  has_many :titles, through: :property_employees

  # Nested attributes
  accepts_nested_attributes_for :property_employees

  # Paperclip
  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  # Validates
  validates_presence_of :address, :city, :state, :zip

  # Search
  searchkick autocomplete: ['full_address']

  # Methods

  # So we can return the correct image path through JSON
  def picture_url
    picture.url(:thumb)
  end

  private

    def set_full_address
      if name.nil?
        self.full_address = "#{address}, #{city}, #{state}, #{zip}"
      else
        self.full_address = "#{name}, #{address}, #{city}, #{state}, #{zip}"
      end
    end

end
