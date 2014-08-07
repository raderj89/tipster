require 'spec_helper'

describe Title do
  it { should validate_presence_of(:title) }
end
