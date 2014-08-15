class PropertyUser < ActiveRecord::Base

  # Relations
  belongs_to :user
  belongs_to :property

  # Validations
  # validates_presence_of :user_id
  validates_presence_of :property_id

  validates :unit, presence: true, length: { maximum: 10 }

  delegate :full_address, to: :property
end
