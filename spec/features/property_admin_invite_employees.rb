require 'spec_helper'

feature 'invite employees' do
  let(:manager_first_time_logged_in) { create(:building_manager_first_login) }
  let(:manager) { create(:building_manager) }
  
  scenario 'on first time logging in' do
    
  end
end