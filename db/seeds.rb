Admin.delete_all
Employee.delete_all
User.delete_all
PropertyEmployee.delete_all
PropertyUser.delete_all
Invitation.delete_all

Admin.create!(email: 'admin@smartytip.com', password: 'password')

TITLES = %w(bellhop porter doorman handyman valet)

25.times do |i|
  property = Property.create!(address: '165 Central Ave',
                              city: Faker::Address.city,
                              state: 'NY',
                              zip: Faker::AddressUS.zip_code,
                              picture: File.new("#{Rails.root}/app/assets/images/Apartments.jpg"))
end

employee_counter = 0
user_counter = 0

Property.all.each do |property|
  10.times do
    employee = Employee.create!(first_name: Faker::Name.first_name,
                                last_name: Faker::Name.last_name,
                                email: "employee-#{employee_counter}@tipster.com",
                                password: 'password',
                                nickname: 'Jay',
                                invitation_id: (rand(99) + 1),
                                avatar: File.new("#{Rails.root}/app/assets/images/bill.jpeg"),
                                tip_average: rand(99))

    property.property_employees.create!(employee_id: employee.id,
                                        title: TITLES.sample,
                                        suggested_tip: rand(99) )
    employee_counter += 1
  end

  10.times do
    user = User.create!(first_name: Faker::Name.first_name,
                        last_name: Faker::Name.last_name,
                        email: "user-#{user_counter}@tipster.com",
                        password: 'password',
                        avatar: File.new("#{Rails.root}/app/assets/images/bill.jpeg"),
                        signature: "The #{Faker::Name.last_name} family")

    property.property_tenants.create!(user_id: user.id, unit: "1L")
    user_counter += 1
  end
end

employee = Employee.find(1)

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
rescue Stripe::InvalidRequestError => e
  puts "Stripe error while creating recipient: #{e.message}"
  false
end

user = User.find(1)

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

