json.(@apartment, :street, :city, :zip, :state, :beds, :baths, :sq_ft, :apartment_type, :price)
json.sale_date @apartment.sale_date.strftime('%d/%m/%Y')
json.created_at @apartment.created_at.strftime('%d/%m/%Y')
