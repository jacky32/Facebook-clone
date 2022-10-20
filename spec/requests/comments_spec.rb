# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', name: 'ete', password: '123456') }
  let(:test_post) { Post.create(user: test_user, text: 'text') }

  before(:each) do
    sign_in test_user
  end

  describe 'GET new' do
    it 'succeeds' do
      get new_post_comment_path(test_post)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new comment' do
        expect do
          post post_comments_path(test_post, format: :turbo_stream), params: {
            comment: {
              text: 'Text text'
            }
          }
        end.to change { Comment.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-stream action="prepend" target="post_' + test_post.id.to_s + ' comments">')
      end
    end

    context 'with invalid params' do
      it 'does not create a new comment' do
        expect do
          post post_comments_path(test_post), params: {
            comment: {
              text: ''
            }
          }
        end.not_to change { Comment.count }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).not_to include('<turbo-stream action="prepend" target="post_' + test_post.id.to_s + ' comments">')
      end
    end
  end
end
