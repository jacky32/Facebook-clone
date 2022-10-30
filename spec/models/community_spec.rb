require 'rails_helper'

RSpec.describe Community, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:admin) }
  end

  describe 'Associations' do
    it { should have_one_attached(:background) }
    it { should have_many(:memberships).with_foreign_key(:community_id) }
    it { should have_many(:members).through(:memberships).source(:member) }
    it { should belong_to(:admin).class_name('User') }
  end
end
