require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:sender) }
    it { should validate_presence_of(:receiver) }
    it { should validate_presence_of(:body) }
  end

  describe 'Associations' do
    it { should belong_to(:sender) }
    it { should belong_to(:receiver) }
  end
end
