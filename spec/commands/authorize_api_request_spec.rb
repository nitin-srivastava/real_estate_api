require 'rails_helper'

RSpec.describe AuthorizeApiRequest do

  describe '#call' do
    let(:user) { create(:user) }

    context 'when token is invalid' do
      let(:header) { { 'Authorization' => expired_token_generator(user.id) } }
      let(:call_response) { described_class.call(header) }

      it { expect(call_response.success?).to be_falsey }
      it { expect(call_response.failure?).to be_truthy }
      it { expect(call_response.errors[:token]).to eq(['Invalid token']) }
      it { expect(call_response.result).to be_nil }
    end

    context 'when token is valid' do
      let(:header) { { 'Authorization' => token_generator(user.id) } }
      let(:call_response) { described_class.call(header) }

      it { expect(call_response.success?).to be_truthy }
      it { expect(call_response.failure?).to be_falsey }
      it { expect(call_response.errors).to eq({}) }
      it { expect(call_response.result).to eq(user) }
    end

  end
end