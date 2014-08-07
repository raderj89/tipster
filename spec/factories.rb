FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "admin-#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end

  factory :manager_invitation, class: 'Invitation' do
    sequence(:recipient_email) { |n| "user-#{n}@example.com" }
    token "dsflkjh3lhrr893"
    sender factory: :admin
  end

  factory :property do
    name "Trump Tower"
    address "123 Rich Person Way"
    city "New York"
    state "New York"
    zip "11372"
  end

  factory :building_manager, class: 'Employee' do
    first_name "Mike"
    last_name "Super"
    sequence(:email) { |n| "manager-#{n}@example.com" }
    password "password"
    is_admin true
    invitation factory: :manager_invitation
  end
  
  factory :property_employee_admin, class: 'PropertyEmployee' do
    employee factory: :building_manager
    property
  end

end