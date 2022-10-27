require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:text) }
  end

  describe 'Associations' do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
  end

  describe 'Database' do
    it { should have_db_column(:text).of_type(:string) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:commentable_id).of_type(:integer) }
    it { should have_db_column(:commentable_type).of_type(:string) }
  end
end
