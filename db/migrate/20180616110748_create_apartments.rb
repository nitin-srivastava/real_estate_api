class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.string :street
      t.string :city
      t.integer :zip
      t.string :state
      t.integer :beds
      t.integer :baths
      t.integer :sq_ft
      t.string :apartment_type
      t.datetime :sale_date
      t.decimal :price
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
