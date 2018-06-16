json.(@apartment, :street, :city, :zip, :state, :beds, :baths, :apartment_type, :price)
json.area_sq_ft @apartment.area
json.sale_date @apartment.sale_date.strftime('%d/%m/%Y')
json.created_at @apartment.created_at.strftime('%d/%m/%Y')
