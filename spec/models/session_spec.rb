require 'rails_helper'

RSpec.describe Session, :type => :model do
  it { should validate_presence_of :user }
  it { should validate_presence_of :token }
  it { should validate_uniqueness_of :token }
end
