require 'spec_helper'

feature 'inviting property admins', js: true do
  let(:admin) { create(:admin) }
  let(:invite) { build(:manager_invitation) }

  before do
    log_in_admin!(admin)

    visit '/admin/invitations/new'

    expect(page).to have_content("Invite property managers")
  end

  scenario 'with valid credentials' do
    fill_in "Email", with: invite.recipient_email

    click_button "Send Invitation"

    wait_for_ajax

    expect(page).to have_field('Email', with: "")

    expect(page).to have_content("Invite sent successfully!")
  end

  scenario 'with invalid credentials' do
    fill_in "Email", with: ''

    click_button "Send Invitation"

    wait_for_ajax

    expect(page).to have_content("There was a problem sending your invitation.")
  end
end
