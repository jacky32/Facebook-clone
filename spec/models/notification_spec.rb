require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:receiver).class_name('User') }
  end
end
