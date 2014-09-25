require 'spec_helper'

feature 'inviting property admins', js: true do
  let(:admin) { create(:admin) }

  before do
    log_in_admin!(admin)

    visit new_admin_invitation_path

    expect(page).to have_content("INVITE PROPERTY MANAGERS")
  end

  scenario 'with valid information' do
    fill_in "Manager Email", with: "bob@trumptower.com"

    click_button "Send Invitation"

    expect(page).to have_field('Email', with: "")

    expect(page).to have_content("Invite sent successfully!")
  end

  scenario 'with invalid information' do
    fill_in "Manager Email", with: ''

    click_button "Send Invitation"

    expect(page).to have_content("There was a problem sending your invitation.")
  end
end
