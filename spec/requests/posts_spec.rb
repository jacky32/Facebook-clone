# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }

  before(:each) do
    sign_in test_user
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new post' do
        expect do
          post posts_path(format: :turbo_stream), params: {
            post: {
              text: 'Text text'
            }
          }
        end.to change { Post.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-stream action="prepend" target="posts">')
      end
    end

    context 'with invalid params' do
      it 'does not create a new post' do
        expect do
          post posts_path, params: {
            post: {
              text: ''
            }
          }
        end.not_to change { Post.count }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).not_to include('<turbo-stream action="prepend" target="posts">')
      end
    end
  end
end
