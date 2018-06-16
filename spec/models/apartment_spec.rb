require 'rails_helper'

RSpec.describe Apartment, type: :model do

  describe 'check validation' do
    let(:apartment_attrs) { build(:apartment).attributes }

    context 'when create with blank street and city' do
      let!(:apartment) { Apartment.new(apartment_attrs.merge(state: nil, city: nil)) }

      before { apartment.save }

      it { expect(apartment.valid?).to be_falsey }
      it { expect(apartment.errors.full_messages).to eq(["City can't be blank", "State can't be blank"]) }
      it { expect(Apartment.count).to eq(0) }
    end

    context 'when create with valid params' do
      let!(:apartment) { Apartment.new(apartment_attrs) }

      before { apartment.save }

      it { expect(apartment.valid?).to be_truthy }
      it { expect(apartment.errors.full_messages).to eq([]) }
      it { expect(Apartment.count).to eq(1) }
    end

  end
end
