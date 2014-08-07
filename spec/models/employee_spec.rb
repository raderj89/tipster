require 'spec_helper'

describe Employee do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should ensure_length_of(:first_name).is_at_most(100) }
  it { should ensure_length_of(:last_name).is_at_most(100) }

  it { should validate_presence_of(:email) }
  it { should allow_value('jared@nycdevshop.com', 'jared-rader@nycdevshop.com', 'jared.rader123@nycdevshop.com').for(:email) }
  it { should ensure_length_of(:email).is_at_most(100) }

  it { should validate_presence_of(:password) }
  it { should have_secure_password }
  it { should ensure_length_of(:password).is_at_least(6) }
end
