# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let(:test_post) { Post.create(user: test_user, text: 'text') }
  let!(:test_comment) { Comment.create(user: test_user, commentable: test_post, text: 'text') }

  before(:each) do
    sign_in test_user
  end

  describe 'GET show' do
    context 'with valid comment id' do
      it 'succeeds' do
        get comment_path(test_comment)
        expect(response).to be_successful
      end
    end
    context 'with invalid comment id' do
      it 'fails' do
        expect { get comment_path(0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new comment on a post' do
        expect do
          post post_comments_path(test_post, format: :turbo_stream), params: {
            comment: {
              text: 'Text text'
            }
          }
        end.to change { Comment.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<turbo-stream action=\"prepend\" target=\"post_#{test_post.id} comments\">")
      end

      it 'creates a new comment on a comment' do
        expect do
          post comment_comments_path(test_comment, format: :turbo_stream), params: {
            comment: {
              text: 'Text text'
            }
          }
        end.to change { Comment.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<turbo-stream action=\"prepend\" target=\"comment_#{test_comment.id} comments\">")
      end
    end

    context 'with invalid params' do
      it 'does not create a new comment on a post' do
        expect do
          post post_comments_path(test_post), params: {
            comment: {
              text: ''
            }
          }
        end.not_to(change { Comment.count })
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).not_to include("<turbo-stream action=\"prepend\" target=\"post_#{test_post.id} comments\">")
      end

      it 'does not create a new comment on a comment' do
        expect do
          post comment_comments_path(test_comment), params: {
            comment: {
              text: ''
            }
          }
        end.not_to(change { Comment.count })
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).not_to include("<turbo-stream action=\"prepend\" target=\"comment_#{test_comment.id} comments\">")
      end
    end
  end

  describe 'PATCH update' do
    context 'with valid params' do
      it 'does update the comment' do
        expect do
          patch comment_path(test_comment), params: {
            comment: {
              id: test_comment.id,
              text: 'text longer'
            }
          }
        end.to change { test_comment.reload.text }.to 'text longer'
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'without valid params' do
      it 'does not update the comment' do
        expect do
          patch comment_path(test_comment), params: {
            comment: {
              id: test_comment.id,
              text: ''
            }
          }
        end.not_to change { test_comment.reload.text }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      it 'does update the comment' do
        expect do
          put comment_path(test_comment), params: {
            comment: {
              id: test_comment.id,
              text: 'text longer'
            }
          }
        end.to change { test_comment.reload.text }.to 'text longer'
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'without valid params' do
      it 'does not update the comment' do
        expect do
          put comment_path(test_comment), params: {
            comment: {
              id: test_comment.id,
              text: ''
            }
          }
        end.not_to change { test_comment.reload.text }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'deletes the comment' do
      expect do
        delete comment_path(test_comment), params: {
          comment: {
            id: test_comment.id,
            text: ''
          }
        }
      end.to change { Comment.count }.by(-1)
    end
  end
end
