class EmployeeAddress < ActiveRecord::Base
  # Relations
  belongs_to :employee

  # Validations
  validates :address_line_1, presence: true
  validates_presence_of :city, :state, :zip
end
