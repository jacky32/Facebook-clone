# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:test_user1) { User.create(email: '1@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user2) { User.create(email: '2@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user3) { User.create(email: '3@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user4) { User.create(email: '4@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user5) { User.create(email: '5@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user6) { User.create(email: '6@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }

  describe 'Validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'Associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:friendships).dependent(:destroy) }
    it { should have_many(:friend_requests) }
    it { should have_many(:memberships).with_foreign_key(:member_id) }
    it { should have_many(:joined_communities).through(:memberships).source(:community) }
    it {
      should have_many(:created_communities).class_name('Community').with_foreign_key(:admin_id).dependent(:destroy)
    }
  end

  describe 'friends' do
    before(:each) do
      request1 = test_user1.friendships.create(friend_id: test_user2.id)
      request2 = test_user1.friendships.create(friend_id: test_user3.id)
      request3 = test_user1.friendships.create(friend_id: test_user4.id)
      request4 = test_user1.friendships.create(friend_id: test_user5.id)
      request1.accepted = true
      request2.accepted = true
      request1.save
      request2.save
      request3.save
      request4.save
    end

    it 'returns friends' do
      response = test_user1.friends
      expect(response).to contain_exactly(test_user2, test_user3)
    end

    it 'does not return unaccepted friends' do
      response = test_user1.friends
      expect(response).not_to include(test_user4)
      expect(response).not_to include(test_user5)
    end

    it 'does not include not requested friends' do
      response = test_user1.friends
      expect(response).not_to include(test_user6)
    end
  end
end
