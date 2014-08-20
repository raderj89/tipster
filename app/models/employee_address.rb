class EmployeeAddress < ActiveRecord::Base
  # Relations
  belongs_to :employee

  # Validations
  validates :address_line_1, presence: true
  validates_presence_of :city, :state, :zip

  def full_address
    if self.address_line_2
      "#{address_line_1},\n#{address_line_2}\n#{city}, #{state}, #{zip}"
    else
      "#{address_line_1},\n#{city}, #{state}, #{zip}"
    end
  end
end
