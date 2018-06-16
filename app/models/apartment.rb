class Apartment < ApplicationRecord
  validates :street, :city, :zip, :state, :beds, :baths, :area, :apartment_type, :price, :sale_date, presence: true
end
