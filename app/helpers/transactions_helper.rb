module TransactionsHelper
  def first_last_initial(employee)
    "#{employee.first_name} #{employee.last_name[0]}."
  end

  def full_property_address(property)
    "#{property.address} #{property.city}, #{property.state}"
  end
end
