# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Communities', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }
  let!(:test_post) { Post.create!(user: test_user, text: 'text') }
  let!(:test_community) { Community.create!(name: 'test', admin: test_user) }

  before(:each) do
    sign_in test_user
  end

  describe 'GET index' do
    it 'succeeds' do
      get communities_path
      expect(response).to be_successful
    end
  end

  describe 'GET show' do
    context 'with valid community id' do
      it 'succeeds' do
        get community_path(test_community)
        expect(response).to be_successful
      end
    end
    context 'with invalid community id' do
      it 'fails' do
        expect { get community_path(0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new community' do
        expect do
          post communities_path(format: :turbo_stream), params: {
            community: {
              name: 'test'
            }
          }
        end.to change { Community.count }.by(1)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('<turbo-stream action="replace" target="main">')
      end
    end

    context 'with invalid params' do
      it 'does not create a new community' do
        expect do
          post communities_path, params: {
            community: {
              name: ''
            }
          }
        end.not_to change { Community.count }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).not_to include('<turbo-stream action="replace" target="main">')
      end
    end
  end

  describe 'PATCH update' do
    context 'with valid params' do
      it 'does update the community' do
        expect do
          patch community_path(test_community), params: {
            community: {
              id: test_community.id,
              name: 'different name'
            }
          }
        end.to change { test_community.reload.name }.to 'different name'
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'without valid params' do
      it 'does not update the community' do
        expect do
          patch community_path(test_community), params: {
            community: {
              id: test_community.id,
              name: ''
            }
          }
        end.not_to change { test_community.reload.name }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      it 'does update the community' do
        expect do
          put community_path(test_community), params: {
            community: {
              id: test_community.id,
              name: 'different name'
            }
          }
        end.to change { test_community.reload.name }.to 'different name'
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'without valid params' do
      it 'does not update the community' do
        expect do
          put community_path(test_community), params: {
            community: {
              id: test_community.id,
              name: ''
            }
          }
        end.not_to change { test_community.reload.name }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'deletes the community' do
      expect do
        delete community_path(test_community), params: {
          community: {
            id: test_community.id
          }
        }
      end.to change { Community.count }.by(-1)
    end
  end
end
