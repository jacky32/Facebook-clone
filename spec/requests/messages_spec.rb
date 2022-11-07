require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let!(:test_user1) { User.create(email: '1@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_user2) { User.create(email: '2@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_chat) { Chat.create!(sender: test_user1, receiver: test_user2) }

  before(:each) do
    sign_in test_user1
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new message' do
        expect do
          post messages_path(format: :turbo_stream), params: {
            message: {
              user_id: test_user1.id,
              chat_id: test_chat.id,
              body: 'message text'
            }
          }
        end.to change { Message.count }.by(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'does not create a new message' do
        expect do
          post messages_path(format: :turbo_stream), params: {
            message: {
              user_id: test_user1.id,
              chat_id: test_chat.id
            }
          }
        end.not_to change { Message.count }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
