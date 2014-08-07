class Title < ActiveRecord::Base
  # Relations
  has_many :employees, inverse_of: :title

  # Validations
  validates_presence_of :title
end
