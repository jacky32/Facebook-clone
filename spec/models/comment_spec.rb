require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:text) }
  end

  describe 'Associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
  end
end
