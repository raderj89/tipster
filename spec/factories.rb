FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "admin-#{n}@example.com" }
    password "password"
    password_confirmation "password"
  end

  factory :manager_invitation, class: 'Invitation' do
    sequence(:recipient_email) { |n| "user-#{n}@example.com" }
    sender factory: :admin
  end 
end