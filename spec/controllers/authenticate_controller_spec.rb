require 'rails_helper'

RSpec.describe AuthenticateController, type: :request do

  describe 'POST login' do
    let(:user) { create(:user) }
    let(:valid_credentials) do
      { email: user.email, password: user.password }
    end

    let(:invalid_credentials) do
      { email: 'foo@bar.com', password: 'foobar123' }
    end

    let(:headers) do
      { "Content-Type" => "application/json" }
    end

    context 'when login successfully' do
      before { post '/api/v1/auth/login', params: valid_credentials }

      it 'should return an authentication token' do
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['auth_token']).not_to be_nil
      end
    end

    context 'when login failed' do
      before { post '/api/v1/auth/login', params: invalid_credentials }

      it 'should return 401' do
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['auth_token']).to be_nil
      end
    end
  end
end
