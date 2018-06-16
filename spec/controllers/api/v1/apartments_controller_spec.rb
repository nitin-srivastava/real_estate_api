require 'rails_helper'

RSpec.describe Api::V1::ApartmentsController do
  let(:user) { create(:user) }
  let(:headers) do
    { 'Authorization' => token_generator(user.id) }
  end
  let!(:apartment) { create(:apartment)}
  let!(:apartment_omaha) do
    create(:apartment, street: '51 OMAHA CT', zip: 95823, sq_ft: 1167,
           price: 68212, latitude: 38.478902, longitude: -121.431028)
  end
  let!(:apartment_peppermill) do
    create(:apartment, street: '5828 PEPPERMILL CT', zip: 95841, sq_ft: 1122,
           apartment_type: 'Condo', price: 89921, latitude: 38.662595, longitude: -121.327813)
  end
  let!(:apartment_trinity) do
    create(:apartment, street: '11150 TRINITY RIVER DR Unit 114', city: 'RANCHO CORDOVA', zip: 95670,
           sq_ft: 941, apartment_type: 'Condo', price: 94905, latitude: 38.621188, longitude: -121.270555)
  end
  let!(:apartment_oakvale) do
    create(:apartment, street: '7511 OAKVALE CT', city: 'NORTH HIGHLANDS', zip: 95660, beds: 4, baths: 2,
           sq_ft: 1240, apartment_type: 'Condo', price: 123000, latitude: 38.621188, longitude: -121.270555)
  end

  before do
    request.headers.merge! headers
  end

  describe 'GET index' do
    let!(:apartments) do
      Apartment.order(:created_at).map do |apartment|
        { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
          'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
          'sq_ft' => apartment.sq_ft, 'apartment_type' => apartment.apartment_type,
          'price' => apartment.price.to_s, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
          'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
      end
    end
    before do
      get :index, format: :json
    end

    it { expect(response.status).to eq(200) }
    it { expect(JSON.parse(response.body)['apartments']).to eq(apartments) }
  end

end