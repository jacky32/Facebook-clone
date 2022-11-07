require 'rails_helper'

RSpec.describe 'UserInfos', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }

  before(:each) do
    sign_in test_user
  end

  describe 'PATCH update' do
    context 'with valid params' do
      it 'does update the user_info' do
        expect do
          patch user_info_path(test_user.user_info), params: {
            user_info: {
              user_id: test_user.id,
              details: 'different details'
            }
          }
        end.to change { test_user.user_info.reload.details }.to 'different details'
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'without valid params' do
      it 'does not update the user_info' do
        expect do
          patch user_info_path(test_user.user_info), params: {
            user_info: {
              user_id: test_user.id
            }
          }
        end.not_to change { test_user.user_info.reload }
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      it 'does update the user_info' do
        expect do
          put user_info_path(test_user.user_info), params: {
            user_info: {
              user_id: test_user.id,
              details: 'different details'
            }
          }
        end.to change { test_user.user_info.reload.details }.to 'different details'
        expect(response).to have_http_status(:redirect)
      end
    end
    context 'without valid params' do
      it 'does not update the user_info' do
        expect do
          put user_info_path(test_user.user_info), params: {
            user_info: {
              user_id: test_user.id
            }
          }
        end.not_to change { test_user.user_info.reload }
      end
    end
  end
end
