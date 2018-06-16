require 'rails_helper'

RSpec.describe Api::V1::ApartmentsController do
  let(:user) { create(:user) }
  let(:headers) do
    { 'Authorization' => token_generator(user.id) }
  end

  before do
    request.headers.merge! headers
  end

  describe 'GET index' do

    context 'without pagination and search params' do
      let!(:apartments) { create_list(:apartment, 33)}
      let!(:result) do
        Apartment.order(:created_at).page(1).per_page(10).map do |apartment|
          { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
            'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
            'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
            'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
            'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
        end
      end

      before do
        get :index, format: :json
      end

      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
      it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>1, 'page_entries'=>10,
                                                                 'total_entries'=>33, 'total_pages'=>4}) }
    end

    context 'with pagination params' do
      let!(:apartments) { create_list(:apartment, 33)}
      let!(:result) do
        Apartment.order(:created_at).page(2).per_page(20).map do |apartment|
          { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
            'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
            'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
            'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
            'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
        end
      end

      before do
        get :index, params: { page: 2, per_page: 20 }, format: :json
      end

      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
      it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>2, 'page_entries'=>13,
                                                                 'total_entries'=>33, 'total_pages'=>2}) }
    end

    context 'with search' do

      let!(:apartment) { create(:apartment)}
      let!(:apartment_omaha) do
        create(:apartment, street: '51 OMAHA CT', zip: 95823, area: 1167,
               price: 68212, latitude: 38.478902, longitude: -121.431028)
      end
      let!(:apartment_peppermill) do
        create(:apartment, street: '5828 PEPPERMILL CT', zip: 95841, area: 1122,
               apartment_type: 'Condo', price: 89921, latitude: 38.662595, longitude: -121.327813)
      end
      let!(:apartment_trinity) do
        create(:apartment, street: '11150 TRINITY RIVER DR Unit 114', city: 'RANCHO CORDOVA', zip: 95670,
               area: 941, apartment_type: 'Condo', price: 94905, latitude: 38.621188, longitude: -121.270555)
      end
      let!(:apartment_oakvale) do
        create(:apartment, street: '7511 OAKVALE CT', city: 'NORTH HIGHLANDS', zip: 95660, beds: 4, baths: 2,
               area: 1240, apartment_type: 'Condo', price: 123000, latitude: 38.621188, longitude: -121.270555)
      end

      context 'by apartment_type' do

        let!(:result) do
          Apartment.where(apartment_type: 'Residential').order(:created_at).map do |apartment|
            { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
              'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
              'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
              'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
              'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
          end
        end
        before do
          get :index, params: { apartment_type: 'Residential' }, format: :json
        end

        it { expect(response.status).to eq(200) }
        it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
        it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>1, 'page_entries'=>2,
                                                                   'total_entries'=>2, 'total_pages'=>1}) }
      end

      context 'by price range min and max.' do

        context 'When search by greater than min price' do
          let!(:result) do
            Apartment.where('price >=?', 90000).order(:created_at).map do |apartment|
              { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
                'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
                'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
                'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
                'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
            end
          end
          before do
            get :index, params: { min_price: 90000 }, format: :json
          end

          it { expect(response.status).to eq(200) }
          it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
          it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>1, 'page_entries'=>2,
                                                                     'total_entries'=>2, 'total_pages'=>1}) }
        end

        context 'When search by less than max price' do
          let!(:result) do
            Apartment.where('price <=?', 90000).order(:created_at).map do |apartment|
              { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
                'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
                'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
                'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
                'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
            end
          end
          before do
            get :index, params: { max_price: 90000 }, format: :json
          end

          it { expect(response.status).to eq(200) }
          it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
          it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>1, 'page_entries'=>3,
                                                                     'total_entries'=>3, 'total_pages'=>1}) }
        end

        context 'When search by given price range' do
          let!(:result) do
            Apartment.where('price >=? AND price <=?', 60000, 100000).order(:created_at).map do |apartment|
              { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
                'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
                'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
                'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
                'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
            end
          end
          before do
            get :index, params: { min_price: 60000, max_price: 100000 }, format: :json
          end

          it { expect(response.status).to eq(200) }
          it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
          it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>1, 'page_entries'=>3,
                                                                     'total_entries'=>3, 'total_pages'=>1}) }
        end
      end

      context 'by min and max area sq feet range.' do

        context 'When search by greater than equal to min area sq feet' do
          let!(:result) do
            Apartment.where('area >=?', 1150).order(:created_at).map do |apartment|
              { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
                'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
                'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
                'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
                'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
            end
          end
          before do
            get :index, params: { min_area: 1150 }, format: :json
          end

          it { expect(response.status).to eq(200) }
          it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
          it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>1, 'page_entries'=>2,
                                                                     'total_entries'=>2, 'total_pages'=>1}) }
        end

        context 'When search by less than equal to max area sq feet' do
          let!(:result) do
            Apartment.where('area <=?', 1000).order(:created_at).map do |apartment|
              { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
                'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
                'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
                'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
                'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
            end
          end
          before do
            get :index, params: { max_area: 1000 }, format: :json
          end

          it { expect(response.status).to eq(200) }
          it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
          it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>1, 'page_entries'=>2,
                                                                     'total_entries'=>2, 'total_pages'=>1}) }
        end

        context 'When search by given area range' do
          let!(:result) do
            Apartment.where('area >=? AND area <=?', 800, 1100).order(:created_at).map do |apartment|
              { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
                'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
                'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
                'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
                'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
            end
          end
          before do
            get :index, params: { min_area: 800, max_area: 1100 }, format: :json
          end

          it { expect(response.status).to eq(200) }
          it { expect(JSON.parse(response.body)['apartments']).to eq(result) }
          it { expect(JSON.parse(response.body)['paginates']).to eq({'current_page'=>1, 'page_entries'=>2,
                                                                     'total_entries'=>2, 'total_pages'=>1}) }
        end
      end
    end
  end

  describe 'GET show' do
    let!(:apartment) { create(:apartment)}
    let!(:result) do
      { 'street' => apartment.street, 'city' => apartment.city, 'zip' => apartment.zip,
        'state' => apartment.state, 'beds' => apartment.beds, 'baths' => apartment.baths,
        'apartment_type' => apartment.apartment_type, 'price' => apartment.price.to_s,
        'area_sq_ft' => apartment.area, 'sale_date' => apartment.sale_date.strftime('%d/%m/%Y'),
        'created_at' => apartment.created_at.strftime('%d/%m/%Y') }
    end

    context 'when id is invalid' do
      before do
        get :show, params: { id: 15 }, format: :json
      end

      it { expect(response.status).to eq(422) }
      it { expect(JSON.parse(response.body)['errors']).to eq('Record not found') }
    end

    context 'when id is valid' do
      before do
        get :show, params: { id: apartment.id }, format: :json
      end

      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)).to eq(result) }
    end
  end

  describe 'POST create' do
    let(:apartment_attrs) { build(:apartment).attributes }

    context 'is unsuccessful' do
      before do
        post :create, params: { apartment: apartment_attrs.merge!('state' => nil, 'city' => nil)}, format: :json
      end

      it { expect(response.status).to eq(422) }
      it { expect(JSON.parse(response.body)['errors']).to eq(["City can't be blank", "State can't be blank"]) }
      it { expect(Apartment.count).to eq(0) }
    end

    context 'is successful' do
      before do
        post :create, params: { apartment: apartment_attrs }, format: :json
      end

      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['success']).to eq('Apartment was created successfully.') }
      it { expect(Apartment.count).to eq(1) }
    end
  end

  describe 'PUT update' do
    let!(:apartment) { create(:apartment)}

    context 'when invalid id' do
      before do
        put :update, params: { id: 15, apartment: apartment.attributes.merge!('zip' => nil, 'city' => nil)}, format: :json
      end

      it { expect(response.status).to eq(422) }
      it { expect(JSON.parse(response.body)['errors']).to eq('Record not found') }
    end

    context 'is unsuccessful' do
      before do
        put :update,
            params: { id: apartment.id, apartment: apartment.attributes.merge!('zip' => nil, 'city' => nil)},
            format: :json
      end

      it { expect(response.status).to eq(422) }
      it { expect(JSON.parse(response.body)['errors']).to eq(["City can't be blank", "Zip can't be blank"]) }
      it { expect(apartment.reload.zip).to eq(95838) }
      it { expect(apartment.reload.city).to eq('SACRAMENTO') }
    end

    context 'is successful' do
      before do
        put :update,
            params: { id: apartment.id, apartment: apartment.attributes.merge!('zip' => 95660, 'city' => 'NORTH HIGHLANDS')},
            format: :json
      end

      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['success']).to eq('Apartment was updated successfully.') }
      it { expect(apartment.reload.zip).to eq(95660) }
      it { expect(apartment.reload.city).to eq('NORTH HIGHLANDS') }
    end
  end

  describe 'DELETE update' do
    let!(:apartment) { create(:apartment)}

    context 'is unsuccessful' do
      before do
        delete :destroy, params: { id: 10 }, format: :json
      end

      it { expect(response.status).to eq(422) }
      it { expect(JSON.parse(response.body)['errors']).to eq('Record not found') }
      it { expect(Apartment.count).to eq(1) }
    end

    context 'is successful' do
      before do
        delete :destroy, params: { id: apartment.id }, format: :json
      end

      it { expect(response.status).to eq(200) }
      it { expect(JSON.parse(response.body)['success']).to eq('Apartment was deleted successfully.') }
      it { expect(Apartment.count).to eq(0) }
    end
  end

end