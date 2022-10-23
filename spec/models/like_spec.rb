require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:user) }
  end

  describe 'Associations' do
    it { should belong_to(:likeable) }
    it { should belong_to(:user) }
  end

  describe 'Database' do
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:likeable_id).of_type(:integer) }
    it { should have_db_column(:likeable_type).of_type(:string) }
  end
end
