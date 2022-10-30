require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe 'Associations' do
    it { should belong_to(:member).class_name('User') }
    it { should belong_to(:community).class_name('Community') }
  end
end
