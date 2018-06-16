json.apartments @apartments do |apartment|
  json.(apartment, :street, :city, :zip, :state, :beds, :baths, :apartment_type, :price)
  json.area_sq_ft apartment.area
  json.sale_date apartment.sale_date.strftime('%d/%m/%Y')
  json.created_at apartment.created_at.strftime('%d/%m/%Y')
end

json.paginates do
  json.current_page @apartments.current_page
  json.page_entries @apartments.size
  json.total_entries @apartments.total_entries
  json.total_pages @apartments.total_pages
end