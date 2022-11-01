require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:sender) }
    it { should validate_presence_of(:receiver) }
  end

  describe 'Associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:receiver).class_name('User') }
    it { should have_many(:messages) }
  end
end
