require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { User.new(email: 'abc@dfe.cz', name: 'ete', password: '123456') }

  before do
    sign_in user
  end

  describe 'GET new' do
    it 'succeeds' do
      get new_post_path
      expect(response).to have_http_status(:success)
    end
  end
end
