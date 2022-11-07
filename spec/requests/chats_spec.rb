# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Chats', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let(:test_user2) { User.create(email: 'abcd@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_chat) { Chat.create!(sender: test_user, receiver: test_user2) }

  before(:each) do
    sign_in test_user
  end

  describe 'GET show' do
    context 'with valid chat id' do
      it 'succeeds' do
        get chat_path(test_chat)
        expect(response).to be_successful
      end
    end
    context 'with invalid chat id' do
      it 'fails' do
        expect { get chat_path(0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new chat' do
        Chat.all.each(&:destroy)
        expect do
          post chats_path(format: :turbo_stream), params: {
            user_id: test_user2.id
          }
        end.to change { Chat.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-stream action="update" target="chat">')
      end
    end

    context 'with invalid params' do
      it 'does not create a new chat' do
        expect do
          post chats_path, params: {
            user_id: ''
          }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
