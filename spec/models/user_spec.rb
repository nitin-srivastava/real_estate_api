require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'authenticate' do
    let(:user) { create(:user, password: 'Hello@123') }

    it { expect(user.authenticate('World@123')).to be_falsey }
    it { expect(user.authenticate('Hello@123')).to be_truthy }
  end
end