module FirstTimeLogIn

  def first_time_log_in(manager_invitation)
    visit new_property_path(manager_invitation.token)

    fill_in 'Name of Building', with: 'Trump Tower'
    fill_in 'Address', with: '123 Rich Person Way'
    fill_in 'City', with: 'New York'
    find('#property_state').find(:xpath, 'option[2]').select_option
    fill_in 'Zip', with: '11372'
    attach_file 'Upload a photo of your building', "#{Rails.root}/spec/support/images/test.jpeg"
    
    find(:xpath, "//input[@id='property_property_employees_attributes_0_title_attributes_title']").set "Super"
    find(:xpath, "//input[@id='property_property_employees_attributes_0_employee_attributes_invitation_token']").set manager_invitation.token
    
    # Property admin form
    fill_in 'First name', with: 'Mike'
    fill_in 'Last name', with: 'Super'
    fill_in 'Nickname', with: 'SuperMike'
    fill_in 'Email', with: manager_invitation.recipient_email
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    attach_file 'Upload a photo of yourself', "#{Rails.root}/spec/support/images/test.jpeg"

    click_button 'Create Account'

    expect(page).to have_content("Your account was successfully created!")
  end

end

RSpec.configure do |c|
  c.include FirstTimeLogIn, type: :feature
end