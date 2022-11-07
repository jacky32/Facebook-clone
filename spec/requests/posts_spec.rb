# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_post) { Post.create!(user: test_user, text: 'text') }

  before(:each) do
    sign_in test_user
  end

  describe 'GET show' do
    context 'with valid post id' do
      it 'succeeds' do
        get post_path(test_post)
        expect(response).to be_successful
      end
    end
    context 'with invalid post id' do
      it 'fails' do
        expect { get post_path(0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
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

  describe 'PATCH update' do
    context 'with valid params' do
      it 'does update the post' do
        expect do
          patch post_path(test_post), params: {
            post: {
              id: test_post.id,
              text: 'text longer'
            }
          }
        end.to change { test_post.reload.text }.to 'text longer'
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'without valid params' do
      it 'does not update the post' do
        expect do
          patch post_path(test_post), params: {
            post: {
              id: test_post.id,
              text: ''
            }
          }
        end.not_to change { test_post.reload.text }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      it 'does update the post' do
        expect do
          put post_path(test_post), params: {
            post: {
              id: test_post.id,
              text: 'text longer'
            }
          }
        end.to change { test_post.reload.text }.to 'text longer'
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'without valid params' do
      it 'does not update the post' do
        expect do
          put post_path(test_post), params: {
            post: {
              id: test_post.id,
              text: ''
            }
          }
        end.not_to change { test_post.reload.text }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'deletes the post' do
      expect do
        delete post_path(test_post), params: {
          post: {
            id: test_post.id,
            text: ''
          }
        }
      end.to change { Post.count }.by(-1)
    end
  end
end
