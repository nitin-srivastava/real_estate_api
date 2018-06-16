class Apartment < ApplicationRecord
  validates :street, :city, :zip, :state, :beds, :baths, :sq_ft, :apartment_type, :price, :sale_date, presence: true
end
