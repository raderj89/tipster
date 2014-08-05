require 'spec_helper'

describe Admin do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value('jared@nycdevshop.com').for(:email) }
  it { should_not allow_value('jared', 'jared@', 'jared@djsk', 'jared@jared.com.').for(:email) }
  it { should allow_value('password').for(:password) }
  it { should_not allow_value('abc').for(:password) }
end
