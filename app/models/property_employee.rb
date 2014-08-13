class PropertyEmployee < ActiveRecord::Base

  # Relations
  belongs_to :employee
  belongs_to :property

  validates_presence_of :property
  validates_presence_of :employee

  accepts_nested_attributes_for :property

  TITLES = [
            [1, "Super"],
            [2, "Bellhop"],
            [3, "Porter"],
            [4, "Handyman"],
            [5, "Valet"],
            [6, "Doorman"]
           ]
end
