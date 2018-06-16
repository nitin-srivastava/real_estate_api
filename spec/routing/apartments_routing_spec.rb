require 'rails_helper'

RSpec.describe Api::V1::ApartmentsController do

  it 'routes to #index' do
    expect(get('/api/v1/apartments')).to route_to('api/v1/apartments#index')
  end

  it 'routes to #show' do
    expect(get('/api/v1/apartments/1')).to route_to('api/v1/apartments#show', id: '1')
  end

  it 'routes to #create' do
    expect(post('/api/v1/apartments')).to route_to('api/v1/apartments#create')
  end

  it 'routes to #update' do
    expect(put('/api/v1/apartments/1')).to route_to('api/v1/apartments#update', id: '1')
  end

  it 'routes to #destroy' do
    expect(delete('/api/v1/apartments/1')).to route_to('api/v1/apartments#destroy', id: '1')
  end
end