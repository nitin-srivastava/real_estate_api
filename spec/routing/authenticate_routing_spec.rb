require 'rails_helper'

RSpec.describe AuthenticateController do
  it 'routes to #login' do
    expect(post('/api/v1/auth/login')).to route_to('authenticate#login')
  end
end