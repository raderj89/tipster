require 'spec_helper'

feature 'signing in' do
  let(:admin) { create(:admin) }
  before { visit '/admin/log_in'}

  scenario 'With valid credentials' do

    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button "Log In"

    expect(page).to have_content("You have logged in successfully.")
  end

  scenario 'With invalid credentials' do
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    click_button "Log In"

    expect(page).to have_content("Incorrect email or password.")
  end
end