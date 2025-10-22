class CreateProductionCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :production_countries do |t|
      t.string :name
      t.string :iso_3166_1

      t.timestamps
    end
  end
end
