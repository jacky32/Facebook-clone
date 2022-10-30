require 'rails_helper'

RSpec.describe UserInfo, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:user) }
  end

  describe 'Associations' do
    it { should have_one_attached(:avatar) }
    it { should belong_to(:user) }
  end
end
