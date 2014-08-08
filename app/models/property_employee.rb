class PropertyEmployee < ActiveRecord::Base

  # Relations
  belongs_to :employee
  belongs_to :property
  belongs_to :title

  # validates_presence_of :employee, :property

  accepts_nested_attributes_for :employee
  accepts_nested_attributes_for :title
end
