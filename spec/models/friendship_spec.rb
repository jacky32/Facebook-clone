# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let!(:test_user1) { User.create(email: '1@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user2) { User.create(email: '2@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }

  describe 'Associations' do
    it { should belong_to(:user) }
  end

  before(:each) do
    Friendship.all.each { |tst| tst.destroy }
  end

  describe 'self.requested?' do
    context 'when request not sent' do
      it 'returns false' do
        response = Friendship.requested?(test_user1.id, test_user2.id)
        expect(response).to be_falsey
      end
    end
    context 'when request sent' do
      before do
        test_user1.friendships.create(friend_id: test_user2.id)
      end

      it 'returns true' do
        response = Friendship.requested?(test_user1.id, test_user2.id)
        expect(response).to be_truthy
      end
    end
  end

  describe 'self.accepted?' do
    context 'when request sent and accepted' do
      before do
        request = test_user1.friendships.create(friend_id: test_user2.id)
        request.accepted = true
        request.save
      end

      it 'returns true' do
        response = Friendship.accepted?(test_user1.id, test_user2.id)
        expect(response).to be_truthy
      end
    end

    context 'when request sent but not accepted' do
      before do
        request = test_user1.friendships.create(friend_id: test_user2.id)
        request.save
      end

      it 'returns false' do
        response = Friendship.accepted?(test_user1.id, test_user2.id)
        expect(response).to be_falsey
      end
    end

    context 'when request not send' do
      it 'returns false' do
        response = Friendship.accepted?(test_user1.id, test_user2.id)
        expect(response).to be_falsey
      end
    end
  end

  describe 'self.exists?' do
    context 'when request exists' do
      before do
        request = test_user1.friendships.create(friend_id: test_user2.id)
        request.save
      end

      it 'returns true' do
        response = Friendship.exists?(test_user1.id, test_user2.id)
        expect(response).to be_truthy
      end
    end

    context 'when request does not exist' do
      it 'returns false' do
        response = Friendship.exists?(test_user1.id, test_user2.id)
        expect(response).to be_falsey
      end
    end
  end

  describe 'self.find_by_ids' do
    context 'when request exists' do
      before do
        request = test_user1.friendships.create(friend_id: test_user2.id)
        request.save
      end

      it 'returns a friendship' do
        response = Friendship.find_by_ids(test_user1.id, test_user2.id)
        expect(response.is_a?(Friendship)).to be_truthy
      end
    end

    context 'when request does not exist' do
      it 'returns false' do
        response = Friendship.find_by_ids(test_user1.id, test_user2.id)
        expect(response).to be_falsey
      end
    end
  end
end
