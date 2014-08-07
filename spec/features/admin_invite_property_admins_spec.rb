require 'spec_helper'

feature 'inviting property admins', js: true do
  let(:admin) { create(:admin) }
  let(:invite) { build(:manager_invitation) }

  # Create some existing invitations
  let!(:invite2) { create(:manager_invitation) }
  let!(:invite3) { create(:manager_invitation) }

  before do
    log_in_admin!(admin)

    visit '/admin/invitations/new'

    expect(page).to have_content("Invite property managers")

    expect(page).to have_selector('.js-sent-invites-list')

    within('.js-sent-invites-list') do
      expect(page.find('li:first-child')).to have_content(invite2.recipient_email)
    end

    expect(page.find('.js-sent-invites-list').all('li').size).to eq Invitation.all.count
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
