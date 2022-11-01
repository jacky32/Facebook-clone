require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:chat) }
    it { should validate_presence_of(:body) }
  end

  describe 'Associations' do
    it { should belong_to(:chat) }
    it { should belong_to(:user) }
  end
end
