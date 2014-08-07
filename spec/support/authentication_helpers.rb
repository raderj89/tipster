module AuthenticationHelpers
  def log_in_admin!(admin)
    visit '/admin/log_in'
    fill_in "Email", with: admin.email
    fill_in "Password", with: admin.password
    click_button 'Log In'
    expect(page).to have_content("You have logged in successfully.")
  end
end

RSpec.configure do |c|
  c.include AuthenticationHelpers, type: :feature
end

module AuthHelpers
  def admin_log_in(admin)
    session[:admin_id] = admin.id
  end
end

RSpec.configure do |c|
  c.include AuthHelpers, type: :controller
end