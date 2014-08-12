Admin.delete_all
Admin.create!(email: 'admin@smartytip.com', password: 'password')

25.times do |i|
  property = Property.create!(address: '165 Central Ave',
                              city: Faker::Address.city,
                              state: 'NY',
                              zip: Faker::AddressUS.zip_code,
                              picture: File.new("#{Rails.root}/app/assets/images/Apartments.jpg"))



  Employee.create(first_name: Faker::Name.first_name,
                   last_name: Faker::Name.last_name,
                   email: "employee-#{i}@tipster.com",
                   password: 'password',
                   nickname: 'Jay',
                   invitation_id: (rand(99) + 1),
                   stripe_id: SecureRandom.urlsafe_base64,
                   )


end