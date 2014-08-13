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

  employee = Employee.create!(first_name: Faker::Name.first_name,
                              last_name: Faker::Name.last_name,
                              email: "employee-#{i}@tipster.com",
                              password: 'password',
                              nickname: 'Jay',
                              invitation_id: (rand(99) + 1),
                              stripe_id: SecureRandom.urlsafe_base64,
                              avatar: File.new("#{Rails.root}/app/assets/images/bill.jpeg"),
                              tip_average: rand(99))

  user = User.create!(first_name: Faker::Name.first_name,
                      last_name: Faker::Name.last_name,
                      email: "user-#{i}@tipster.com",
                      password: 'password',
                      avatar: File.new("#{Rails.root}/app/assets/images/bill.jpeg"),
                      signature: "The #{Faker::Name.last_name} family",
                      stripe_id: SecureRandom.urlsafe_base64)

  property.property_employees.create!(employee_id: employee.id,
                                      title: TITLES.sample,
                                      suggested_tip: rand(99) )

  property.property_tenants.create!(user_id: user.id, unit: "1L")

end