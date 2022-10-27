# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let(:test_post) { Post.create(user: test_user, text: 'text') }
  let!(:test_comment) { Comment.create(user: test_user, commentable: test_post, text: 'text') }

  before(:each) do
    sign_in test_user
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new like on a post' do
        expect { post post_likes_path(test_post, format: :turbo_stream) }.to change { Like.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<turbo-stream action=\"update\" target=\"post_#{test_post.id}_like\">")
      end

      it 'creates a new like on a comment' do
        expect { post comment_likes_path(test_comment, format: :turbo_stream) }.to change { Like.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<turbo-stream action=\"update\" target=\"comment_#{test_comment.id}_like\">")
      end
    end
  end

  describe 'DELETE destroy' do
    context 'on post' do
      let!(:test_like) { Like.create(user: test_user, likeable: test_post) }
      # it 'removes the like from the database' do
      #   expect { test_like.destroy }.to change { Like.count }.by(-1)
      #   expect(test_like.persisted?).to be_falsey
      # end
      it 'removes the like from the database' do
        expect { delete post_like_path(test_post, test_like, format: :turbo_stream) }.to change { Like.count }.by(-1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<turbo-stream action=\"update\" target=\"post_#{test_post.id}_like\">")
        expect(flash.now[:notice]).to be_present
      end
    end

    context 'on comment' do
      let!(:test_like) { Like.create(user: test_user, likeable: test_comment) }
      # it 'removes the like from the database' do
      #   expect { test_like.destroy }.to change { Like.count }.by(-1)
      #   expect(test_like.persisted?).to be_falsey
      # end
      it 'removes the like from the database' do
        expect { delete comment_like_path(test_comment, test_like, format: :turbo_stream) }.to change {
                                                                                                 Like.count
                                                                                               }.by(-1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("<turbo-stream action=\"update\" target=\"comment_#{test_comment.id}_like\">")
        expect(flash.now[:notice]).to be_present
      end
    end
  end
end
