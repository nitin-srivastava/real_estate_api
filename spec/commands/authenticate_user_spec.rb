require 'rails_helper'

RSpec.describe AuthenticateUser do

  let(:user) { create(:user) }

  describe '#call' do

    context 'with valid credentials' do
      let(:authenticate_user) { AuthenticateUser.call(user.email, user.password) }
      it { expect(authenticate_user.success?).to be_truthy }
      it { expect(authenticate_user.failure?).to be_falsey }
      it { expect(authenticate_user.errors).to eq({}) }
      it { expect(authenticate_user).to_not be_nil }
    end

    context 'with invalid credentials' do
      let(:authenticate_user) { AuthenticateUser.call('hello@world.com', 'Hello') }
      it { expect(authenticate_user.success?).to be_falsey }
      it { expect(authenticate_user.failure?).to be_truthy }
      it { expect(authenticate_user.errors[:user_authentication]).to eq(['Invalid credentials']) }
      it { expect(authenticate_user).to_not be_nil }
    end
  end
end