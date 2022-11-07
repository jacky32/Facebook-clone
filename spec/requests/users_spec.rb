require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:test_user) { User.create(email: 'abc@dfe.cz', first_name: 'ete', last_name: 'eee', password: '123456') }

  before(:each) do
    sign_in test_user
  end

  describe 'GET show' do
    context 'with valid user id' do
      it 'succeeds' do
        get user_path(test_user)
        expect(response).to be_successful
      end
    end
    context 'with invalid user id' do
      it 'fails' do
        expect { get user_path(0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
