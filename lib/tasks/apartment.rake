namespace :apartment do

  require 'csv'

  desc 'Import apartment CSV'
  task import: :environment do
    filename = File.read("#{Rails.root}/db/Sacramentorealestatetransactions.csv")
    begin
      CSV.parse(filename, :headers => true) do |row|
        attrs = {
          street: row['street'], city: row['city'], zip: row['zip'], state: row['state'], beds: row['beds'],
          baths: row['baths'], area: row['sq_ft'], apartment_type: row['type'], price: row['price'],
          sale_date: Time.parse(row['sale_date']), latitude: row['latitude'], longitude: row['longitude']
        }
        Apartment.create(attrs)
      end
      puts 'All done!'
    rescue Exception => e
      puts e.message
    end
  end

end