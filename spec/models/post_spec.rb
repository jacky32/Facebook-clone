require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Validations' do
    let(:test_user) do
      User.create!(email: 'test@test.com', name: 'Name', password: 'Password')
    end

    subject { described_class.new(user: test_user, text: 'Text') }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without text' do
      subject.text = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without user' do
      subject.user_id = nil
      expect(subject).not_to be_valid
    end
  end
end
