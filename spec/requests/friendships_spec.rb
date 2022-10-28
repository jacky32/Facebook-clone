# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Friendships', type: :request do
  let!(:test_user1) { User.create(email: '1@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user2) { User.create(email: '2@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user3) { User.create(email: '3@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }

  before(:each) do
    sign_in test_user1
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'sends a friend request' do
        expect do
          post friendships_path(format: :turbo_stream), params: {
            user_id: test_user1.id,
            friend_id: test_user2.id
          }
        end.to change { Friendship.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-stream action="replace" target="friend-list">')
      end

      it 'accepts a friend request' do
        friendship = test_user2.friendships.create(friend_id: test_user1.id)
        friendship.save
        friendship.reload

        expect do
          post friendships_path(format: :turbo_stream), params: {
            user_id: test_user1.id,
            friend_id: test_user2.id
          }
        end.not_to change { Friendship.count }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-stream action="replace" target="friend-list">')
        expect(friendship.reload.accepted).to be_truthy
      end
    end
  end

  describe 'PATCH update' do
    it 'does establish the friendship' do
      friendship = test_user2.friendships.create(friend_id: test_user1.id)
      friendship.save
      friendship.reload

      expect do
        patch friendship_path(friendship), params: {}
      end.to change { friendship.reload.accepted }.to be_truthy
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'DELETE destroy' do
    it 'removes the friendship' do
      friendship = test_user2.friendships.create(friend_id: test_user1.id)
      friendship.accepted = true
      friendship.save
      friendship.reload
      expect do
        delete friendship_path(friendship), params: {}
      end.to change { Friendship.count }.by(-1)
    end
  end
end
