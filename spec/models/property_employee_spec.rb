require 'spec_helper'

describe PropertyEmployee do
  it { should validate_presence_of(:employee) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:property) }
end
