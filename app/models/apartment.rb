class Apartment < ApplicationRecord
  validates :street, :city, :zip, :state, :beds, :baths, :area, :apartment_type, :price, :sale_date, presence: true

  SEARCH_KEYS = %w(apartment_type min_price max_price min_area max_area).freeze
end
