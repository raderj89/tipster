require 'spec_helper'

feature 'invite employees', js: true do
  let(:manager_invitation1) { double(:manager_invitation, token: 'fasfwer3', recipient_email: 'jared+1@nycdevshop.com') }
  let(:employee_invitation) { double(:employee_invitation, recipient_email: 'shawn@nycdevshop.com', position: 'bellhop') }
  let(:manager_first_time_logged_in) { create(:building_manager_first_login) }
  let(:manager) { create(:building_manager) }

  scenario 'on first time logging in' do
    

    expect(page).to have_content("Invite Employees")

    fill_in 'Employee Email Address', with: 'employee@example.com'
    find('#invitation_position').find(:xpath, 'option[2]').select_option

    click_button 'Send Invitation'

    wait_for_ajax

    expect(page).to have_field('Email', with: "")

    expect(page).to have_content("Invite sent successfully!")

    within('.js-sent-invites-list') do
      expect(page.find('li:first-child')).to have_content(employee_invitation.recipient_email)
    end
  end
end