class PropertyEmployee < ActiveRecord::Base

  # Relations
  belongs_to :employee
  belongs_to :property

  validates_presence_of :property
  validates_presence_of :employee

  accepts_nested_attributes_for :property

  delegate :name, :address, :city_state_zip, :full_address, :picture_thumb, to: :property
  delegate :full_name, :avatar_thumb, to: :employee

  TITLES = [
            "Resident Manager",
            "Porter",
            "Night Porter",
            "Night Package Room",
            "Service Elevator",
            "Relief Porter",
            "Handyman",
            "Day Captain",
            "Night Captain",
            "Day Doorman",
            "Night Doorman",
            "Mail Clerk",
            "Lobby Porter"
           ]

end
