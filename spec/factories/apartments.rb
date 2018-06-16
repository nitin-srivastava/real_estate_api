FactoryBot.define do
  factory :apartment do
    street '3526 HIGH ST'
    city 'SACRAMENTO'
    zip 95838
    state 'CA'
    beds 2
    baths 1
    area 836
    apartment_type 'Residential'
    sale_date Time.current
    price 59222
    latitude 38.631913
    longitude 121.434879
  end
end