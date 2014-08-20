Admin.delete_all
Employee.delete_all
User.delete_all
PropertyEmployee.delete_all
PropertyUser.delete_all
Invitation.delete_all
Property.delete_all
Transaction.delete_all
Tip.delete_all

Admin.create!(email: 'admin@smartytip.com', password: 'password')

10.times do |i|
  property = Property.create!(address: '165 Central Ave',
                              city: Faker::Address.city,
                              state: 'NY',
                              zip: Faker::AddressUS.zip_code,
                              picture: File.new("#{Rails.root}/app/assets/images/Apartments.jpg"))
end

employee_admin_counter = 0
employee_counter = 0
user_counter = 0

Property.all.each do |property|

  1.times do
    employee = Employee.create!(first_name: Faker::Name.first_name,
                                last_name: Faker::Name.last_name,
                                email: "admin-employee-#{employee_admin_counter}@tipster.com",
                                password: 'password',
                                nickname: 'Jay',
                                invitation_id: (rand(99) + 1),
                                avatar: File.new("#{Rails.root}/app/assets/images/bill.jpeg"),
                                tip_average: rand(99),
                                is_admin: true)

    prop_employee = property.property_employees.create!(employee_id: employee.id,
                                                        title: PropertyEmployee::TITLES[0],
                                                        suggested_tip: ((rand(100)).round(-1)))
    employee_admin_counter += 1
  end

  12.times do
    employee = Employee.create!(first_name: Faker::Name.first_name,
                                last_name: Faker::Name.last_name,
                                email: "employee-#{employee_counter}@tipster.com",
                                password: 'password',
                                nickname: 'Jay',
                                invitation_id: (rand(99) + 1),
                                avatar: File.new("#{Rails.root}/app/assets/images/bill.jpeg"),
                                tip_average: rand(99),
                                is_admin: false)


    property.property_employees.create!(employee_id: employee.id,
                                        title: PropertyEmployee::TITLES[(rand(11) + 1)],
                                        suggested_tip: ((rand(100)).round(-1)))
    employee_counter += 1
  end

  2.times do
    user = User.create!(first_name: Faker::Name.first_name,
                        last_name: Faker::Name.last_name,
                        email: "user-#{user_counter}@tipster.com",
                        password: 'password',
                        avatar: File.new("#{Rails.root}/app/assets/images/bill.jpeg"),
                        signature: "The #{Faker::Name.last_name} family")

    user.property_relations.create!(property_id: property.id, unit: "1L")

    user_counter += 1
  end
end

employee = Employee.first

begin
  recipient = Stripe::Recipient.create(name: employee.full_name,
                                       type: 'individual',
                                       email: employee.email,
                                       bank_account: {
                                        account_number: '000123456789',
                                        routing_number: '110000000',
                                        country: 'US'} )
  employee.stripe_id = recipient.id
  employee.save!
  method = employee.build_deposit_method(last_four: '6789')
  method.save!
rescue Stripe::InvalidRequestError => e
  puts "Stripe error while creating recipient: #{e.message}"
  false
end

user = User.first

begin
  customer = Stripe::Customer.create(description: user.full_name,
                                     email: user.email,
                                     card: { number: 4242424242424242,
                                             exp_month: 11,
                                             exp_year: 2016,
                                             cvc: 123 })
  user.stripe_id = customer.id
  user.save!
rescue Stripe::CardError => e
  puts "Stripe error while creating customer: #{e.message}"
  false
end

Property.all.each do |property|
  property.tenants.each do |tenant|
    8.times do |i|
      transaction = tenant.transactions.build(created_at: (Time.now - i.weeks.ago), property_id: property.id)
      property.employees.each do |employee|
        transaction.employee_tips.build(employee_id: employee.id,
                                        message: "Thanks #{employee.first_name}, you're the best. Hope you get some peace and quiet this holiday!",
                                        amount: (rand(100) + 1))

      end
      transaction.save!
    end
  end
end
