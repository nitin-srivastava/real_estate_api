require 'rails_helper'

RSpec.describe JsonWebToken do
  let(:user) { create(:user) }

  describe 'encode' do
    let(:token) { 'abcdefg12345678' }
    before do
      allow(JWT).to receive(:encode).and_return(token)
    end

    it { expect(JsonWebToken.encode(user_id: user.id)).to eq(token) }
  end

  describe 'decode' do
    context 'when token is nil' do
      it { expect(JsonWebToken.decode(nil)).to eq('Nil JSON web token') }
    end

    context 'when token is invalid' do
      it { expect(JsonWebToken.decode('priweipoi1231')).to eq('Not enough or too many segments') }
    end

    context 'when token is valid' do
      let(:token) { 'abcdefg12345678' }
      before do
        allow(JWT).to receive(:decode).and_return({})
      end
      it { expect(JsonWebToken.decode(token)).to eq({}) }
    end
  end

end